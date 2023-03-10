import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:zoom_widget/zoom_widget.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-connection-379407",
  "private_key_id": "08b936070905cad573fdde8f87732e70bf57fd90",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDi3gzdPthn3q3z\nUXHpoZ1/lXEGa3TRUCRWBtBJMyYpOFyTi0en5Mh2VMG1tC6kV41lPlTHsmvEnSe/\n5YUiKEsDa398R9dYlsZvrGdea+qE0JVR5pM6ZTrGmDrcbI12cZxruidajVYvhmsB\nz5frLJu6SdCcaJcu/Zb9D9mYJ+45P9s4IYJdj+q3FCeeaoWKwVhR6cZGHADsdDm/\nQiXbc3MQraQT1F5I1RrD5at7wGtqAw5/iPEuB0mYFSCa3S/CLxV+0uYJu/hd14pc\nmjNv2wZXyodeM8/zoe95B6yYypmtV4ho//onpJm4GPvUX2YxsF+VIGiNExfiaC1E\nrNWuxiy1AgMBAAECggEAATZXvtrpULmTSy71OxIraeId8rKiTJGidnjRphwWD4RT\nyLbaBCvbZZGtLOmW+J1xjcfxr6HkpFSFDagOHqrOc8852CuRTmtH1iyHeBN/JlFW\nN7prfciXfs/GolgZWjeszID38t25RyzvTdj5Ij8tYEDcUrZwXSzq7W4NpwJK0JcX\nMASUYK/scNFVjuBGOpYe8+/y7FKigs43UuYiYjwNs9caRDeG3xkyN9BVQstxoeo9\nomGOQ/2Q2iyFkmI3TmUi/HTymrY/4mv0FJleIrVVHOwSSHd7Lxj+RySSD93rGRgf\nfpNm6yPDDe1486ujFkVzZiGes9PPx60C+Jgmmu5TQQKBgQDzZXZ6msgyIe5C3Ubr\nedsYw1pI0OoxmIcaFP/NqHXE9+hA5SmOyQO4J7cPLnv30H4tWf1K5K2OxbuttlUw\nAHkPloAel8pMMMm//ZBINi0MMuuTq60GdjKfaTtXNySQKrFgNs8Vr3qUZLmLdQH5\nL/z4uNH90aNQhqDmt3W1WSxgcQKBgQDunXl4lIGYwOF9Fu+fk8l9pnaXbepK1tSd\nBb09d4hTYgO83PHyRuVUa9Mt+NUGkBvME9zB9ULkGEDHwlQtgoU0jP7Qd1BqCmBR\n73OGSkwBj3a0ur1t+5+5Ok6+COsR+xqwPPB+m+zEM0MEhFy51GxxQQabYgYRtiMz\n1VmhXwIyhQKBgEmrIB0j1Aw4cOEUEG8dRs9L8Xuwn/G69MlUKciZgGvJjSZ3Ngjd\nlp6ahrG1pBfxpv8bCastY8qe1ptRYJ9SxVGOf+DCmJxO+AGAQbdZjnDuyJa9k3Ut\nOU0+kJNpQUvRYDZ64Frz7eoUQoSPObWubKbracOlPAUXeoPaa2okP2ZBAoGBALOI\nrMK7Ch+C0KYrwbPRoIL34rbhLq2MooBatx4ud9Y1IxbRLwHZsecpEcW/OZksiJ2u\nPCV7gg7Y6LTkVC3BzLPTek4j189Ra1N61PMvp6xs4yXsc2bzMiRN6L03PJdU1anQ\n0CqS6zxcTYpyhMoVOFqmUHBM+sAMyMPRPRUbxS15AoGBAMlJFcl8X6iHe3Irl6gt\n54dtDvzO9P4zBQBcQXEmdnJr8eoionAY/4Rl2xNSOmTk9z42p+ehS/OXs9LD8GIy\nivvXcbyhXLAJU/97bpkzk9ckxaEgQTXaHjI5FXMJ8XtvmoJDQEslS6rJxe1o+wel\nN7YgPOYyTCnbStb8EKKhPhJ5\n-----END PRIVATE KEY-----\n",
  "client_email": "schedulegsheet@gsheets-connection-379407.iam.gserviceaccount.com",
  "client_id": "118131499537657069596",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/schedulegsheet%40gsheets-connection-379407.iam.gserviceaccount.com"
}
''';

const _spreadsheetId = '13m48URp1VHOhgMPWFgoNQP76vZUvKomfVLp1NfR1Cpk';
// const _spreadsheetId = '1EMU2RSEs9erD6F2UBPfvbHCFSOaJBsnXr297o-BunwU';

class WeeklyTable extends StatelessWidget {
  const WeeklyTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Table Example'),
      ),
      body: Zoom(
          initTotalZoomOut: true,
          child: Container(
            child: const MakeTable(),
          )
      )
    );
  }
}

class MakeTable extends StatelessWidget {
  const MakeTable({super.key});

  @override
  Widget build(BuildContext context) {
    /* 컬럼만들기 */
    // 요일 가져오기
    List<String> weekly = getWeekly();

    /* 로우만들기 */
    // 시간 가져오기
    List<String> timeList = getTimeList(22);

    // 구글시트 읽기
    setDataCol();



    // 시트 매칭

    return DataTable(
      dataRowHeight: 50,
      columns: <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              '',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        for (int i=0; i<weekly.length; i++)
          DataColumn(
            label: Expanded(
              child: Text(
                weekly[i],
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
      ],
      rows: <DataRow>[
        for (int i=0; i<timeList.length; i++)
          DataRow(
            cells: <DataCell>[
              DataCell(
                  Container(
                      width: 60,
                      child: Text(timeList[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                  )
              ),
              for (int i=0; i<weekly.length; i++)
              DataCell(TextField(controller: TextEditingController(text: 'Student')))
            ],
          ),
      ],
    );
  }

  void setColumns() {



  }

  List<String> getWeekly() {
    List<String> dayList = ['월', '화', '수', '목', '금', '토', '일'];
    List<String> colNmList = [];
    DateTime now = DateTime.now();
    int currentDay = now.weekday;

    for (int i=0; i<dayList.length; i++) {
      DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay-i - 1));
      String mergeDay = "${firstDayOfWeek.month}/${firstDayOfWeek.day}(${dayList[i]})";
      colNmList.add(mergeDay);
    }

    return colNmList;
  }

  List<String> getTimeList(int finalHour) {
    DateTime now = DateTime.now();
    DateTime initTime = new DateTime(now.year, now.month, now.day, 08, 00, 00);
    List<String> timeList = [];

    do {
      initTime = initTime.add(Duration(minutes: 30));
      String timeFormat = DateFormat("a hh:mm").format(initTime);
      timeList.add(timeFormat);
    } while(initTime.hour < finalHour);

    return timeList;
  }

  void setDataCol() async {
    // init GSheets
    final gsheets = GSheets(_credentials);
    // fetch spreadsheet by its id
    final ss = await gsheets.spreadsheet(_spreadsheetId);

    var sheet = await ss.worksheetByTitle('2/27-3/5');
    // var sheet = await ss.worksheetById(248829237);

    if (sheet != null) {
      Future<List<List<Cell>>> data = sheet.cells.allRows(fromRow: 5, fromColumn: 3);

      data.asStream().forEach((cols) {
        cols.forEach((col) {
          col.forEach((element) {
            // if (!element.value.contains("(민영)") || '' == element.value) {
            //   element.value = '';
            // }
            print('${element.row-3} : ${element.column-1} => ${element.value}');
          });
        });
      });

    }
  }
}


