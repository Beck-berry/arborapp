import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  Widget bekezdes(String szoveg) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(szoveg,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.justify));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Budai Arborétum'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                bekezdes(
                    'A Budai Arborétum Magyarország egyik legjelentősebb arborétuma a XI. kerületben található. Az arborétum kiemelt zöldfelület, amely fontos ökológiai és kondicionáló szerepet játszik a kerület életében és Budapest zöldfelületi rendszerében. A kert a Gellért-hegy déli lejtőjén, a Villányi, Szüret, Balogh és Somlói utcák között helyezkedik el, a Ménesi út pedig két részre, Felső- és Alsókertre osztja a területet.'),
                bekezdes(
                    'Entz Ferenc 1853-ban alapította meg a Kertészeti Gyakorló Intézetet, amelynek létrehozása szorosan kapcsolódik az arborétum történetéhez. Az intézet 1976-ban költözött a Gellért-hegyre.'),
                bekezdes(
                    'A jelenlegi Felső kert telepítése 1893 telén kezdődött. Tervezője Räde Károly kertész-dendrológus volt. Räde rendszertani szempontok szerint telepítette a növényeket. Ezen az eredeti, több, mint 100 éves fák ma is a Felső kert térszerkezetének meghatározó elemei.'),
                bekezdes(
                    'Az Alsókert eredetileg a Kertészeti Intézet kísérleti és szaporító telepe volt, ahol üvegházi és szabadföldi termesztés folyt. Az 1970-es évek a nagy ültetések korszaka volt, először Nagy Béla és Nádasi Mihály, majd 1974-től, Schmidt Gábor vezetésével évről évre gyarapodott a kert növényanyaga. Az Alsókertet azonban már nem rendszertani szempontok szerint ültették, hanem a nagyobb növényveszteségek elkerülése érdekében igyekeztek az azonos igényű taxonokat egy helyre ültetni.'),
                bekezdes(
                    'A Budai Arborétum teljes területe 7,5 hektár. A terület a Budai-hegység délkeleti lejtőin helyezkedik el, közel 80 méter szintkülönbséggel.'),
                bekezdes(
                    'Az arborétum jelenlegi növényállománya több, mint 2000 fás szárú dísznövényfajt és fajtát, több száz hagymás virágot és közel 250 egyéb évelő dísznövényfajt tartalmaz.'),
                bekezdes(
                    'Kiemelkedő dendrológiai értékeit, környezeti jelentőségét és a magyar kertészeti felsőoktatásában betöltött fontos szerepét felismerve a főváros vezetése 1975. március 5-i határozatával természetvédelmi területté nyilvánította az arborétumot.'),
              ],
            )));
  }
}
