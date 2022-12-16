String weekdayToString(int i) {
    String val = "";
    switch (i) {
      case 1:
        val = "Sun";
        break;
      case 2:
        val = "Mon";
        break;
      case 3:
        val = "Tue";
        break;
      case 4:
        val = "Wed";
        break;
      case 5:
        val = "Thu";
        break;
      case 6:
        val = "Fri";
        break;
      case 7:
        val = "Sat";
        break;

      default:
    }
    return val;
  }