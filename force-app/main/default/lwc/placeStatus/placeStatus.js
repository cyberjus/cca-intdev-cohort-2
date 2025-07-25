import { LightningElement, api } from "lwc";
import findPlace from "@salesforce/apex/PlaceStatusController.findPlace";
import savePlace from "@salesforce/apex/PlaceStatusController.savePlace";

export default class PlaceStatus extends LightningElement {
  @api recordId;
  setPlace = false;

  place;
  error;

  get hasPlaceId() {
    return this.setPlace || !this.place.potentialPlaceId;
  }

  connectedCallback() {
    findPlace({ accountId: this.recordId })
      .then((data) => {
        this.place = data;
      })
      .catch((error) => {
        this.error = error;
      });
  }

  handleClickSave() {
    savePlace({
      accountId: this.recordId,
      placeId: this.place.data.potentialPlaceId
    });
    this.setPlace = true;
  }
}
