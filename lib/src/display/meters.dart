part of couclient;

class Meters {
  Element meter = querySelector('ur-meters');
  Element currantElement = querySelector('#currCurrants');
  Element currantLabel = querySelector("#currantLabel");

  updateImgDisplay() {
    meter.attributes['imagination'] = metabolics.img.toString();
  }

  updateEnergyDisplay() {
    meter.attributes['energy'] = metabolics.energy.toString();
    meter.attributes['maxenergy'] = metabolics.maxEnergy.toString();
  }

  updateMoodDisplay() {
    meter.attributes['mood'] = metabolics.mood.toString();
    meter.attributes['maxmood'] = metabolics.maxMood.toString();
  }

  updateCurrantsDisplay() {
    currantElement.text = commaFormatter.format(metabolics.currants);
    currantLabel.text = (metabolics.currants != 1 ? "Currants" : "Currant");
  }

  updateNameDisplay() {
    meter.attributes['playername'] = game.username;
  }

  updateAll() {
    updateCurrantsDisplay();
    updateEnergyDisplay();
    updateImgDisplay();
    updateMoodDisplay();
  }
}