#tool nuget:?package=Wyam&version=2.2.9
#addin nuget:?package=Cake.Wyam&version=2.2.9
#addin nuget:?package=Cake.Git&version=0.21.0

var target = Argument("target", "Preview");

Task("Clean")
    .Does(() =>
    {
        try {
            DeleteDirectory("output", new DeleteDirectorySettings {
                Recursive = true,
                Force = true
            });
        } catch (IOException ex) {
            Verbose(ex.Message);
        }
        DeleteFiles(GetFiles("./config.wyam.*"));
    });

Task("Build")
    .IsDependentOn("Clean")
    .Does(() =>
    {
        Wyam(new WyamSettings
        {
            UpdatePackages = true
        });
    });

Task("Deploy")
    .IsDependentOn("Build")
    .Does(() =>
    {
        
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