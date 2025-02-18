import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../models/location_data.dart';

class LocationPicker extends StatefulWidget {
  final Function(String country, String city) onLocationSelected;

  const LocationPicker({
    Key? key,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locationData = LocationData.getLocationData(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 顶部标题栏
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.selectRegion,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // 地区列表
          Expanded(
            child: Row(
              children: [
                // 国家列表
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey.shade50,
                    child: ListView.builder(
                      itemCount: locationData.keys.length,
                      itemBuilder: (context, index) {
                        final country = locationData.keys.elementAt(index);
                        return ListTile(
                          selected: _selectedCountry == country,
                          selectedTileColor: Colors.white,
                          title: Text(country),
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                // 城市列表
                Expanded(
                  flex: 3,
                  child: _selectedCountry == null
                      ? Center(
                          child: Text(l10n.pleaseSelectCountry),
                        )
                      : ListView.builder(
                          itemCount: locationData[_selectedCountry]!.length,
                          itemBuilder: (context, index) {
                            final city = locationData[_selectedCountry]![index];
                            return ListTile(
                              title: Text(city),
                              onTap: () {
                                widget.onLocationSelected(
                                    _selectedCountry!, city);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
