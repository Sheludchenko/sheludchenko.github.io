#tool nuget:?package=Wyam&version=2.2.9
#addin nuget:?package=Cake.Wyam&version=2.2.9
#addin nuget:?package=Cake.Git&version=0.21.0

var target = Argument("target", "Preview");

Task("Clean")
    .Does(() =>
    {
        Func<IFileSystemInfo, bool> exlude_src = fileSystemInfo => !fileSystemInfo.Path.FullPath.Contains("src");
		DeleteDirectories(GetDirectories("../*", new GlobberSettings { Predicate = exlude_src }), new DeleteDirectorySettings {
			Recursive = true,
			Force = true
        });
		DeleteFiles(GetFiles("../*", new GlobberSettings { FilePredicate = exlude_gitignore }));
    });

Task("Build")
    .IsDependentOn("Clean")
    .Does(() =>
    {
        Wyam(new WyamSettings
        {
            NoClean = true,
			OutputPath = "../",
            UpdatePackages = true
        });
    });

Task("Preview")
    .Does(() =>
    {
        Wyam(new WyamSettings
        {
            UpdatePackages = true,
            Preview = true,
            Watch = true
        });
    });

RunTarget(target);