function onEdit(e) {
  var r = e.range;
  if(r.getSheet().getName() == "Sheet1" && r.getColumn() > 1 && r.getRow() > 1 )
  {
    var targetsheet = SpreadsheetApp.openByUrl("https://docs.google.com/spreadsheets/d/1et9U4LonejvDw2me6ARdcvntMW2YvWTF2TYztD6gwVA/edit?usp=sharing").getSheetByName("Sheet1");
    targetsheet.getRange(r.getA1Notation()).setValues(r.getValues());
  }
}
