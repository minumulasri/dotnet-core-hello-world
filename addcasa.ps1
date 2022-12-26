# Place the script in the solution folder
# Add the ca.ruleset to the solution folder
# Run the Powershell Script to add Code Analysis and StyleCop to all your .NET Core Projects.
$projects = (Get-ChildItem . -recurse) | Where-Object {$_.extension -eq ".csproj"}
foreach ($project in $projects) {
    $content = Get-Content $project.FullName
    if (!($content | Select-String -pattern "<CodeAnalysisRuleSet>ca.ruleset</CodeAnalysisRuleSet>")) {
        $content = $content.Replace("</Project>", "`t<PropertyGroup>`r`n`t`t<CodeAnalysisRuleSet>ca.ruleset</CodeAnalysisRuleSet>`r`n`t</PropertyGroup>`r`n</Project>")
        $content | Out-File $project.FullName -Encoding Default
    }
    dotnet add $project.FullName package Microsoft.CodeAnalysis.FxCopAnalyzers
    dotnet add $project.FullName package StyleCop.Analyzers
    Copy-Item ".\ca.ruleset" -Destination "$($project.Directory.FullName)\ca.ruleset"
}
dotnet restore
