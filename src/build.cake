#tool nuget:?package=Wyam&version=2.2.9
#addin nuget:?package=Cake.Wyam&version=2.2.9

var target = Argument("target", "Preview");

Task("Clean")
    .Does(() =>
    {
        string[] excludedDirectories = {".git","src"};
        Func<IFileSystemInfo, bool> excludeDirectories = fileSystemInfo => !excludedDirectories.Contains(fileSystemInfo.Path.Segments[fileSystemInfo.Path.Segments.Length - 1]);
        DeleteDirectories(GetDirectories("../*", new GlobberSettings { Predicate = excludeDirectories }), new DeleteDirectorySettings {
			Recursive = true,
			Force = true
        });

        string[] excludedFiles = {".gitignore","readme.md"};
        Func<IFileSystemInfo, bool>	excludeFiles = fileSystemInfo => !excludedFiles.Contains(fileSystemInfo.Path.Segments[fileSystemInfo.Path.Segments.Length - 1]);
		DeleteFiles(GetFiles("../*", new GlobberSettings { FilePredicate = excludeFiles }));
    });

Task("Publish")
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