import 'package:rx_command/rx_command.dart';
import 'package:geolocation/geolocation.dart';

import 'package:flutter_learning/pages/weather_app/model/model.dart';
import 'package:flutter_learning/pages/weather_app/model/weather_repo.dart';

class ModelCommand{
  final WeatherRepo weatherRepoCommand;

  final RxCommand<Null, LocationResult> updateLocationCommand;
  final RxCommand<LocationResult, List<WeatherModel>> updateWeatherCommand;
  final RxCommand<Null, bool> getGpsCommand;     //ask user for using gps

  ModelCommand._(
      this.weatherRepoCommand,
      this.updateLocationCommand,
      this.updateWeatherCommand,
      this.getGpsCommand);

  factory ModelCommand(WeatherRepo repo){
    final _getGps = RxCommand.createAsyncNoResult<bool>((param) => repo.getGps());   //createAsyncNoResult for the function doesnt have a parameter
    final _updateLocation = RxCommand.createAsyncNoResult<LocationResult>((param) => repo.updateLocation());
    //final _radioCheck = RxCommand.createSyncNoParamNoResult<bool, bool>((b) => b);

    //final _updateWeather = RxCommand.createAsyncNoParamNoResult<LocationResult, List<WeatherModel>>(()repo.updateWeather => _radioCheck.results);
  }

  //_updateLocationCommand.results.listen((data) => _updateWeatherCommand(data));

  //return ModelCommand._(
  //    repo,
  //    _updateLocation,
  //    _getGps,
  //    );
}