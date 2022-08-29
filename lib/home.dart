import 'package:flutter/material.dart';

import 'size_config.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int xScore = 0;
  int oScore = 0;

  List<List<bool>> game = [
    [null, null, null],
    [null, null, null],
    [null, null, null]
  ];

  bool turn = true;
  bool isEnabled = true;
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          score(),
          board(),
          texts(),
          SizedBox(height: getProportionateScreenHeight(24)),
          FlatButton.icon(
            icon: Icon(Icons.refresh),
            label: Text('NOVO JOGO'),
            color: Colors.amber[600],
            onPressed: () {
              setState(() {
                turn = true;
                winner = '';
                isEnabled = true;
                game = [
                  [null, null, null],
                  [null, null, null],
                  [null, null, null]
                ];
              });
            },
          ),
          SizedBox(height: getProportionateScreenHeight(104)),
        ],
      ),
    );
  }

  Text texts() {
    switch (winner) {
      case '':
        return Text.rich(
          TextSpan(
            text: 'É a vez de ',
            style: TextStyle(
                fontSize: getProportionateScreenHeight(24),
                fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: (turn) ? 'X' : 'O',
                style: TextStyle(
                    color: (turn) ? Colors.blue[900] : Colors.red[900]),
                children: [
                  TextSpan(
                      text: ' jogar', style: TextStyle(color: Colors.black)),
                ],
              )
            ],
          ),
        );
        break;
      case 'E':
        return Text(
          'EMPATE!',
          style: TextStyle(
            fontSize: getProportionateScreenHeight(40),
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      default:
        return Text.rich(
          TextSpan(
              text: winner,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(40),
                fontWeight: FontWeight.bold,
                color: winner == 'X' ? Colors.blue[900] : Colors.red[900],
              ),
              children: [
                TextSpan(
                  text: ' VENCEU!!',
                  style: TextStyle(color: Colors.black),
                )
              ]),
        );
        break;
    }
  }

  Widget score() {
    return Text.rich(
      TextSpan(
        text: '$xScore',
        style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenHeight(40)),
        children: [
          TextSpan(
            text: '  x  ',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: getProportionateScreenHeight(32)),
          ),
          TextSpan(
            text: '$oScore',
            style: TextStyle(color: Colors.red[900]),
          ),
        ],
      ),
    );
  }

  Widget board() {
    Widget buildCell(int i, int j) {
      return Container(
        alignment: Alignment.center,
        width: getProportionateScreenWidth(180),
        height: getProportionateScreenWidth(180),
        child: game[i][j] != null
            ? game[i][j]
                ? Icon(
                    Icons.close,
                    size: 50,
                    color: Colors.blue[900],
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red[900],
                    child: Icon(
                      Icons.circle,
                      size: 30,
                      color: Colors.white,
                    ),
                  )
            : FlatButton(
                padding: EdgeInsets.all(0),
                child: Container(),
                color: Colors.amber,
                onPressed: isEnabled
                    ? () {
                        setState(() {
                          game[i][j] = turn;
                          turn = !turn;
                          verifyGame(i, j);
                        });
                      }
                    : null,
              ),
      );
    }

    Widget buildRow(int i) {
      return Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildCell(i, 0),
            VerticalDivider(
              color: Colors.grey[800],
              thickness: 10,
            ),
            buildCell(i, 1),
            VerticalDivider(
              color: Colors.grey[800],
              thickness: 10,
            ),
            buildCell(i, 2),
          ],
        ),
      );
    }

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(100)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildRow(0),
              Divider(
                color: Colors.grey[800],
                thickness: 10,
              ),
              buildRow(1),
              Divider(
                color: Colors.grey[800],
                thickness: 10,
              ),
              buildRow(2),
            ],
          ),
        ),
      ),
    );
  }

  void verifyGame(int i, int j) {
    // verifica as linhas
    if (game[i].every((element) => element == true)) {
      winner = 'X';
      xScore++;
      isEnabled = false;
      return;
    } else if (game[i].every((element) => element == false)) {
      winner = 'O';
      oScore++;
      isEnabled = false;
      return;
    }
    // verifica as colunas
    List<bool> colunas = [];
    for (var index = 0; index < 3; index++) {
      colunas.add(game[index][j]);
    }
    if (colunas.every((element) => element == true)) {
      winner = 'X';
      xScore++;
      isEnabled = false;
      return;
    } else if (colunas.every((element) => element == false)) {
      winner = 'O';
      oScore++;
      isEnabled = false;
      return;
    }
    // verifica as diagonais
    List<bool> diagonalEsquerda = [];
    List<bool> diagonalDireita = [];
    for (var index = 0; index < 3; index++) {
      diagonalEsquerda.add(game[index][index]);
      diagonalDireita.add(game[index][2 - index]);
    }
    if (diagonalEsquerda.every((element) => element == true) ||
        diagonalDireita.every((element) => element == true)) {
      winner = 'X';
      xScore++;
      isEnabled = false;
      return;
    } else if (diagonalEsquerda.every((element) => element == false) ||
        diagonalDireita.every((element) => element == false)) {
      winner = 'O';
      oScore++;
      isEnabled = false;
      return;
    }
    // empate
    var empate = [];
    for (var index = 0; index < 3; index++) {
      empate.add(game[index].every((element) => element != null));
    }
    if (empate.every((element) => element == true)) {
      winner = 'E';
      isEnabled = false;
    }
  }
}
