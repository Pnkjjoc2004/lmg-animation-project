void main() {
  List<int> numbers = [9, 7, 6, 5, 9, 3, 4, 4, 2];

  List<int> uniqueList = [];

  for (int i = 0; i < numbers.length; i++) {
    bool isDuplicate = false;

    for (int j = 0; j < uniqueList.length; j++) {
      if (numbers[i] == uniqueList[j]) {
        isDuplicate = true;
        break;
      }
    }

    if (!isDuplicate) {
      uniqueList.add(numbers[i]);
    }
  }

  for (int i = 0; i < uniqueList.length - 1; i++) {
    for (int j = 0; j < uniqueList.length - i - 1; j++) {
      if (uniqueList[j] > uniqueList[j + 1]) {
        int temp = uniqueList[j];
        uniqueList[j] = uniqueList[j + 1];
        uniqueList[j + 1] = temp;
      }
    }
  }

  print(uniqueList);
}
