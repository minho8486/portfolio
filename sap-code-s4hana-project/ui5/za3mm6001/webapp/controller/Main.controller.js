sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageBox",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/ui/model/json/JSONModel"
], function (Controller, MessageBox, Filter, FilterOperator, JSONModel) {
    "use strict";

    return Controller.extend("ncode1.za3mm6001.controller.Main", {

        onInit: function () {
            let oBefore14 = new Date();
            oBefore14.setDate(oBefore14.getDate() - 14);

            let oData = {
                        matidLow: "M20080000000001",
                        matidHigh: "M20080000000009",
                        plaidLow: "",
                        plaidHigh: "",
                        hsdatLow: oBefore14,
                        hsdatHigh: new Date()
                    };
                    let oModel = new JSONModel(oData);
                    this.getView().setModel(oModel, "cond");
        },
        onSearch() {
                let oView = this.getView();
                let oModel = oView.getModel("cond");
                let oDataCond = oModel.getData();
                let aFilters = [];

                this._addRangeFilter(aFilters, "Matid", oDataCond.matidLow, oDataCond.matidHigh);
                this._addRangeFilter(aFilters, "Plaid", oDataCond.plaidLow, oDataCond.plaidHigh);
                this._addRangeFilter(
                    aFilters,
                    "Hsdat",
                    new Date(oDataCond.hsdatLow),
                    new Date(oDataCond.hsdatHigh)
                );

                this.byId("tabIdList").getBinding("items").filter(aFilters);
        },
        _addRangeFilter: function (aFilters, sField, sLow, sHigh) {
            if (sLow && sHigh) {
                aFilters.push(new sap.ui.model.Filter(
                    sField,
                    sap.ui.model.FilterOperator.BT,
                    sLow,
                    sHigh
                ));
            } else if (sLow) {
                aFilters.push(new sap.ui.model.Filter(
                    sField,
                    sap.ui.model.FilterOperator.EQ,
                    sLow
                ));
            }
        }
    });
});