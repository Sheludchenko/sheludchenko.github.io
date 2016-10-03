[CmdletBinding()]
param (
    [Parameter(Position=0,Mandatory=$false)]
    [ValidateSet('build','init','clean','wipe')]
    [string]$action,
    [Parameter(Mandatory=$false)]
    [int]$postsperpage = 5
)

$posttemplate = ".\src\templates\post.tmpl"
$maintemplate = ".\src\templates\main.tmpl"
$exludeclean = @('.gitignore','sbe.ps1','commonmark.dll','robots.txt','CNAME')

function clean() {
    Remove-Item ".\index*" -Force -Confirm:$false
    Remove-Item ".\posts\*" -Force -Confirm:$false
}

function wipe() {
    Get-ChildItem ".\" -Recurse -Exclude $exludeclean | Remove-Item -Force -Recurse -Confirm:$false;
}

function init() {
    (Get-ChildItem ".\" -Recurse -Exclude $exludeclean | Measure-Object).Count -gt 0 | ? { $_ } | % { Write-Host "Warning: Folder already contains some items. Run clean command before"; Exit 0; }
    New-Item -Path .\src\templates,.\posts,.\src\posts,.\images -ItemType Directory | Out-Null
    Write-Output "<!--content--><!--prevpage--><!--nextpage-->" | Out-File .\src\templates\main.tmpl -Confirm:$false -Force
    Write-Output "<!--content-->" | Out-File .\src\templates\post.tmpl -Confirm:$false -Force
}

function preparepost($post) {
    
    $postfile = "$(($post.Name.Split("-")[1]).Replace("md","html"))"
    $postname = ($post.Name.Split("-")[1]).Replace(".md","").Replace("_"," ")
    $preparedpost = "<div class=""post""><a href=""posts/$postfile""><h1 class=""post-heading"">$postname</h1></a>$([CommonMark.CommonMarkConverter]::Convert($(Get-Content $post.FullName -Raw)))</div>"
    $savepost = (Get-Content $posttemplate).Replace("<!--content-->", $preparedpost) | Set-Content ".\posts\$postfile" -Force -Confirm:$false
    
    return $preparedpost
}

function build() {

    Add-Type -Path ".\commonmark.dll" -PassThru | Out-Null
    
    Remove-Item ".\index*" -Force -Confirm:$false
    Remove-Item ".\posts\*" -Force -Confirm:$false

    $posts = Get-ChildItem ".\src\posts" -Filter "*.md"
    $postscount = ($posts | Measure-Object).Count
    $postnumber = 1
    $pagenumber = 1
    foreach ($post in $posts) {
        
        $postcontent = preparepost $post
        $mainpagecontent += $postcontent

        if ($postscount -eq $postnumber) {
            $mainpage = (Get-Content $maintemplate).Replace("<!--content-->", $mainpagecontent)
            
            if ($pagenumber -eq 2) {
                $mainpage = $mainpage.Replace("<!--prevpage-->", "index.html")
                $mainpage = $mainpage.Replace("<!--nextpage-->", "index.html")
                
            }
            elseif ($pagenumber -gt 2)
            {
                $mainpage = $mainpage.Replace("<!--prevpage-->", "index$($pagenumber - 1).html")
                $mainpage = $mainpage.Replace("<!--nextpage-->", "index.html")
            }

            $pagename = ".\index$($pagenumber).html"
            $pagenumber -eq 1 | ? { $_ } | % { $pagename = ".\index.html" }
            $mainpage | Set-Content $pagename -Force -Confirm:$false
        }
        elseif ($postnumber -eq ($postsperpage * $pagenumber) -and $pagenumber -ne 1) {
            $mainpage = (Get-Content $maintemplate).Replace("<!--content-->", $mainpagecontent)
            if ($pagenumber -eq 2) {
                $mainpage = $mainpage.Replace("<!--prevpage-->", "index.html")
                $mainpage = $mainpage.Replace("<!--nextpage-->", "index$($pagenumber + 1).html")
            }
            elseif ($pagenumber -gt 2)
            {
                $mainpage = $mainpage.Replace("<!--prevpage-->", "index$($pagenumber - 1).html")
                $mainpage = $mainpage.Replace("<!--nextpage-->", "index$($pagenumber + 1).html")
            }
            
            $mainpage | Set-Content ".\index$($pagenumber).html" -Force -Confirm:$false;
            $pagenumber++
            $postnumber++
            $mainpagecontent = $null
        }
        elseif ($postnumber -eq ($postsperpage * $pagenumber) -and $pagenumber -eq 1) {
            $mainpage = (Get-Content $maintemplate).Replace("<!--content-->", $mainpagecontent) 
            $mainpage = $mainpage.Replace("<!--nextpage-->", "index$($pagenumber + 1).html")
            $mainpage | Set-Content ".\index.html" -Force -Confirm:$false;
            $pagenumber++
            $postnumber++
            $mainpagecontent = $null
        }
        elseif ($postnumber -lt ($postsperpage * $pagenumber)) {
            $postnumber++
        }
    }
}

$action | ? { $_ -eq 'build' } | % { build }
$action | ? { $_ -eq 'init' } | % { init }
$action | ? { $_ -eq 'clean' } | % { clean }
$action | ? { $_ -eq 'wipe' } | % { wipe }