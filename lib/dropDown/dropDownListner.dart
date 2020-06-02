enum PageList{
  AllNews,
  Articles,
  Local,
  Forign,
  Sport,
  Whether,
}

abstract class DropDownListner{
  dropDownClickListner(PageList page);
}