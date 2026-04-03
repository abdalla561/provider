void main() {
  final dayOrder = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  final activeSchedules = [
    {
      'days': ['friday', 'monday'],
      'startTime': '00:00:00',
      'endTime': '23:59:59',
      'label': 'متاح دائماً (24/7)',
    }
  ];

  final List<Map<String, dynamic>> flattenedDays = [];
  for (var schedule in activeSchedules) {
    for (var day in schedule['days'] as List<String>) {
      String sTime = schedule['startTime'] as String;
      String eTime = schedule['endTime'] as String;
      if (sTime.length > 5) sTime = sTime.substring(0, 5);
      if (eTime.length > 5) eTime = eTime.substring(0, 5);

      flattenedDays.add({
        'day': day.toLowerCase(),
        'startTime': sTime,
        'endTime': eTime,
        'label': schedule['label'],
      });
    }
  }

  flattenedDays.sort((a, b) {
    int indexA = dayOrder.indexOf(a['day'] as String);
    int indexB = dayOrder.indexOf(b['day'] as String);
    if (indexA == -1) indexA = 99;
    if (indexB == -1) indexB = 99;
    return indexA.compareTo(indexB);
  });

  print(flattenedDays);
}
