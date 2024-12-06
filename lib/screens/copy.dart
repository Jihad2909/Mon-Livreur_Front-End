
/*

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
  duration: Duration(seconds: 1),
  content: Container(
      padding: EdgeInsets.all(16),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
            Radius.circular(20)),
      ),
      child: Center(
          child: Text(
        "Problem de sauvegardé la Coli ! ",
        style: TextStyle(
          fontSize: 20,
        ),
      ))),
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.transparent,
  elevation: 0,
),
);

showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('An error occurred'),
      content: Text('User exist'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/phone');
          },
        ),
      ],
    );
  });

*/