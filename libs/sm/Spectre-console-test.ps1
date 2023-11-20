# using namespace Spectre.Console;
# add-type -path sm/packages/Spectre.Console.0.47.0/lib/net7.0/Spectre.Console.dll
# $spectreTable = new-object -typename Grid
# $spectreTable.AddColumn("Package")
# $spectreTable.AddColumn("Version")
# #$spectreTable.AddColumn("Description")
# #$spectreTable.AddColumn("downloads")
# $spectreTable.AddColumn((New-Object TableColumn("Package")))
# # Define a callback function to add rows
# # Define a callback function to add rows
# function Add-TableRow {
#   param ($t, $column1, $column2)
#   $row = $t.AddRow()
#   $row.Cells[0].AddContent($column1)
#   $row.Cells[1].AddContent($column2)
# }
# # Add some rows using the callback function
# Add-TableRow $spectreTable "Baz" "[green]Qux[/]"
# Add-TableRow $spectreTable (New-Object Spectre.Console.Markup "[blue]Corgi[/]") (New-Object Spectre.Console.Panel "Waldo")

# [AnsiConsole]::Render($spectreTable)



add-type -path packages/Spectre.Console.0.47.0/lib/net7.0/Spectre.Console.dll

$tableObject = new-object Spectre.Console.grid
$panel = new-object Spectre.Console.Panel("MyPanel")


$PackageGid = new-object Spectre.Console.GridColumn -ArgumentList "Package"
$Version = new-object Spectre.Console.Tablecolumn("Version")
$Description = new-object Spectre.Console.Tablecolumn("Description")
$downloads = new-object Spectre.Console.Tablecolumn("downloads")

$IRenderableColoum = New-Object Spectre.Console.Rendering

$tableObject.AddColumn( ($PackageGid.Alignment=[Spectre.Console.Justify]::Center) )
# $tableObject.AddColumn($Version)
# $tableObject.AddColumn($Description)
# $tableObject.AddColumn($downloads)
# $tableObject.AddRow("Baz", "[green]Qux[/]", "Corgi", "Waldo")


#[Spectre.Console.AnsiConsole]::render($tableObject)


# SimpleSpectreWrapper
# for use with powershell

add-type -path packages/Spectre.Console.0.47.0/lib/net7.0/Spectre.Console.dll
Add-Type -Path G:\devspace\projects\c#\SimpleSpectreWrapper