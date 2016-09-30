[CmdletBinding()]
param (
    [Parameter(Position=0,Mandatory=$false)]
    [ValidateSet('build','init','clean','wipe')]
    [string]$action
)

function clean() {
    Remove-Item ".\index*" -Force -Confirm:$false
    Remove-Item ".\posts\*" -Force -Confirm:$false
}

function wipe() {
    Get-ChildItem ".\" -Recurse -Exclude .gitignore,sbe.ps1,commonmark.dll,robots.txt,CNAME | Remove-Item -Force -Recurse -Confirm:$false;
}

function init() {
    (Get-ChildItem ".\" -Recurse -Exclude .gitignore,sbe.ps1,commonmark.dll,robots.txt,CNAME | Measure-Object).Count -gt 0 | ? { $_ } | % { Write-Host "Warning: Folder already contains some items. Run clean command before"; Exit 0; }
    New-Item -Path .\src\templates,.\posts,.\src\posts,.\images -ItemType Directory | Out-Null
    Write-Output "<content placeholder>" | Out-File .\src\templates\main.tmpl -Confirm:$false -Force
    Write-Output "<content placeholder>" | Out-File .\src\templates\post.tmpl -Confirm:$false -Force
}

function build() {
    Add-Type -Path ".\commonmark.dll" -PassThru | Out-Null
    
    Remove-Item ".\index*" -Force -Confirm:$false
    Remove-Item ".\posts\*" -Force -Confirm:$false

    $postsperpage = 5
    $postscount = 0
    $pagenumber = 0
    Get-ChildItem ".\src\posts" -Filter "*.md" | % {
        $postcontent = Get-Content $_.FullName -Raw
        $postconverted = "<div class=""post"">$([CommonMark.CommonMarkConverter]::Convert($postcontent))</div>"
        $mainpagecontent = $mainpagecontent + $postconverted

        $postsrcfile = $_.Name
        $postdstfile = ".\posts\$(($postsrcfile.Split("-")[1]).Replace("md","html"))"

        (Get-Content ".\src\templates\post.tmpl").Replace("<content placeholder>", $postconverted) | Set-Content $postdstfile -Force -Confirm:$false 
        Write-Output "[INFO] .\src\posts\$postsrcfile -> $postdstfile"
        
        if ($postscount % $postsperpage -eq $postsperpage - 1) {
            $pagenumber -eq 0 | ? { $_ } | % { $pagefile = ".\index.html" }
            $pagenumber -gt 0 | ? { $_ } | % { $pagefile = ".\index$($pagenumber).html" }
            (Get-Content ".\src\templates\main.tmpl").Replace("<content placeholder>", $mainpagecontent) | Set-Content $pagefile -Force -Confirm:$false;
            $pagenumber++
            $mainpagecontent = $null
        }
        $postscount++
    }

    $pagenumber -ne 0 | ? { $_ } | % { (Get-Content ".\src\templates\main.tmpl").Replace("<content placeholder>", $mainpagecontent) | Set-Content ".\index$($pagenumber).html" -Force -Confirm:$false; }
}

$action | ? { $_ -eq 'build' } | % { build }
$action | ? { $_ -eq 'init' } | % { init }
$action | ? { $_ -eq 'clean' } | % { clean }
$action | ? { $_ -eq 'wipe' } | % { wipe }