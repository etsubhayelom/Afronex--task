import 'package:weather/consts/consts.dart';
import 'package:weather/views/home.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<City> cities =
        City.citiesList.where((city) => city.isDefault == false).toList();
    List<City> selectedCities = City.getSelectedCities();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Center(child: Text('${selectedCities.length}selected')),
      ),
      body: ListView.builder(
          itemCount: cities.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(left: 10, top: 20, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: size.height * .08,
              width: size.width,
              decoration: BoxDecoration(
                  border: cities[index].isSelected == true
                      ? Border.all(
                          color: secondaryColor.withOpacity(.6),
                          width: 2,
                        )
                      : Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Row(children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        cities[index].isSelected = !cities[index].isSelected;
                      });
                    },
                    child: Image.asset(
                      cities[index].isSelected == true
                          ? 'assets/checked.png'
                          : 'assets/unchecked.png',
                      width: 30,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  cities[index].city,
                  style: TextStyle(
                    fontSize: 16,
                    color: cities[index].isSelected == true
                        ? primaryColor
                        : Colors.black54,
                  ),
                )
              ]),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        child: const Icon(Icons.pin_drop),
        onPressed: () {
          Get.to(() => const HomeScreen());
        },
      ),
    );
  }
}
