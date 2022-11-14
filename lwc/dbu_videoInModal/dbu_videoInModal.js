import { LightningElement, api } from "lwc";

export default class Dbu_videoInModal extends LightningElement {
  @api ismodalopen;
  @api videourl;

  closeModal() {
    this.ismodalopen = false;
    //--Dispatching the event to c/dbu_productDetailImages component to chaning the attribute value as false.
    this.dispatchEvent(new CustomEvent("close"));
  }
}