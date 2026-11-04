sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageBox",
    "sap/m/MessageToast"
], function (Controller, JSONModel, Filter, FilterOperator, MessageBox, MessageToast) {
    "use strict";

    return Controller.extend("zpa3.zgwa3mm6002.controller.Main", {

        onInit: function () {
            this.getView().setModel(new JSONModel(this._getCondInitData()), "cond");
            this.getView().setModel(new JSONModel({}), "adjust");

            this._setInvenChartProperties();
        },

        _getCondInitData: function () {
            return {
                Matid: "M20080000000001",
                Batid: "",
                Plaid: "P000000001",
                Stoid: ""
            };
        },

        _setInvenChartProperties: function () {
            var oChart = this.byId("idInvenChart");

            if (!oChart) {
                return;
            }

            oChart.setVizProperties({
                title: {
                    visible: true,
                    text: "자재별 집계 재고"
                },
                plotArea: {
                    dataLabel: {
                        visible: true
                    }
                },
                valueAxis: {
                    title: {
                        visible: true,
                        text: "재고수량"
                    }
                },
                categoryAxis: {
                    title: {
                        visible: true,
                        text: "자재 / 단위"
                    }
                },
                legend: {
                    visible: false
                }
            });
        },

        onSearch: function () {
            var oCond = this.getView().getModel("cond").getData();
            var aFilters = [];

            if (!this._validateSearchCond(oCond)) {
                return;
            }

            this._addEqFilter(aFilters, "Matid", oCond.Matid);
            this._addEqFilter(aFilters, "Batid", oCond.Batid);
            this._addEqFilter(aFilters, "Plaid", oCond.Plaid);
            this._addEqFilter(aFilters, "Stoid", oCond.Stoid);

            var oBinding = this.byId("idStockTable").getBinding("items");

            if (oBinding) {
                if (oBinding.isSuspended()) {
                    oBinding.resume();
                }

                oBinding.attachEventOnce("dataReceived", function (oEvent) {
                    var oError = oEvent.getParameter("error");

                    if (oError) {
                        MessageBox.error(this._getODataErrorMessage(oError));
                    }
                }.bind(this));

                oBinding.filter(aFilters);
            }
        },

        _validateSearchCond: function (oCond) {
            if (!oCond.Matid) {
                MessageBox.error("자재번호는 필수입니다.");
                return false;
            }

            if (!oCond.Plaid) {
                MessageBox.error("플랜트는 필수입니다.");
                return false;
            }

            return true;
        },

        onReset: function () {
            this.getView().getModel("cond").setData(this._getCondInitData());
            this.getView().getModel("adjust").setData({});

            var oTable = this.byId("idStockTable");
            var oBinding = oTable.getBinding("items");

            oTable.removeSelections(true);

            if (oBinding) {
                oBinding.filter([
                    new Filter("Matid", FilterOperator.EQ, "__EMPTY__")
                ]);
            }
        },

        onOpenAdjustDialog: function () {
            var oTable = this.byId("idStockTable");
            var oSelectedItem = oTable.getSelectedItem();

            if (!oSelectedItem) {
                MessageBox.error("조정할 재고를 선택하세요.");
                return;
            }

            var oSelectedData = oSelectedItem.getBindingContext().getObject();

            this.getView().getModel("adjust").setData({
                Matid: oSelectedData.Matid,
                Batid: oSelectedData.Batid,
                Plaid: oSelectedData.Plaid,
                Stoid: oSelectedData.Stoid,
                Labst: oSelectedData.Labst,
                Meins: oSelectedData.Meins,
                Adjty: "A",
                Adjqt: "",
                Bktxt: ""
            });

            if (!this._oAdjustDialog) {
                this._oAdjustDialog = sap.ui.xmlfragment(
                    "zpa3.zgwa3mm6002.view.AdjustDialog",
                    this
                );
                this.getView().addDependent(this._oAdjustDialog);
            }

            this._oAdjustDialog.open();
        },

        onCloseAdjustDialog: function () {
            if (this._oAdjustDialog) {
                this._oAdjustDialog.close();
            }
        },

        onSaveAdjust: function () {
            var oAdjust = this.getView().getModel("adjust").getData();

            if (!this._validateAdjust(oAdjust)) {
                return;
            }

            var oModel = this.getView().getModel();

            var oPayload = {
                Matid: oAdjust.Matid,
                Batid: oAdjust.Batid,
                Plaid: oAdjust.Plaid,
                Stoid: oAdjust.Stoid,
                Adjty: oAdjust.Adjty,
                Adjqt: oAdjust.Adjqt,
                Bktxt: oAdjust.Bktxt
            };

            var that = this;

            oModel.create("/esStockAdjSet", oPayload, {
                success: function (oResult) {
                    if (oResult.Sflag === "E") {
                        MessageBox.error(oResult.Smesg);
                        return;
                    }

                    MessageToast.show(oResult.Smesg || "재고 조정이 완료되었습니다.");

                    that.onCloseAdjustDialog();
                    that.byId("idStockTable").removeSelections(true);
                    that.onSearch();

                    var oChart = that.byId("idInvenChart");
                    if (oChart && oChart.getDataset()) {
                        oChart.getDataset().getBinding("data").refresh(true);
                    }
                },
                error: function (oError) {
                    MessageBox.error(that._getODataErrorMessage(oError));
                }
            });
        },

        _validateAdjust: function (oAdjust) {
            if (!oAdjust.Adjty) {
                MessageBox.error("조정구분을 선택하세요.");
                return false;
            }

            if (!oAdjust.Adjqt || Number(oAdjust.Adjqt) <= 0) {
                MessageBox.error("조정수량은 0보다 커야 합니다.");
                return false;
            }

            if (oAdjust.Adjty === "S" &&
                Number(oAdjust.Adjqt) > Number(oAdjust.Labst)) {
                MessageBox.error("감소 수량은 현재재고보다 클 수 없습니다.");
                return false;
            }

            return true;
        },

        _addEqFilter: function (aFilters, sField, vValue) {
            if (vValue) {
                aFilters.push(new Filter(sField, FilterOperator.EQ, vValue));
            }
        },

        _getODataErrorMessage: function (oError) {
            var sMessage = "처리 중 오류가 발생했습니다.";

            try {
                if (oError && oError.responseText) {
                    var oResponse = JSON.parse(oError.responseText);

                    if (oResponse.error && oResponse.error.message) {
                        if (typeof oResponse.error.message === "string") {
                            sMessage = oResponse.error.message;
                        } else if (oResponse.error.message.value) {
                            sMessage = oResponse.error.message.value;
                        }
                    }
                } else if (oError && oError.message) {
                    sMessage = oError.message;
                }
            } catch (e) {
                if (oError && oError.responseText) {
                    sMessage = oError.responseText;
                }
            }

            return sMessage;
        },

        onShMatid: function () {
            this._openSearchHelp("Matid");
        },

        onShPlaid: function () {
            this._openSearchHelp("Plaid");
        },

        onShBatid: function () {
            var sMatid = this.getView().getModel("cond").getProperty("/Matid");

            if (!sMatid) {
                MessageBox.error("먼저 자재번호를 선택하세요.");
                return;
            }

            this._openSearchHelp("Batid");
        },

        onShStoid: function () {
            var sPlaid = this.getView().getModel("cond").getProperty("/Plaid");

            if (!sPlaid) {
                MessageBox.error("먼저 플랜트를 선택하세요.");
                return;
            }

            this._openSearchHelp("Stoid");
        },

        _openSearchHelp: function (sType) {
            var sFragmentName = "";

            switch (sType) {
                case "Matid":
                    sFragmentName = "zpa3.zgwa3mm6002.view.ShMatid";
                    break;
                case "Plaid":
                    sFragmentName = "zpa3.zgwa3mm6002.view.ShPlaid";
                    break;
                case "Batid":
                    sFragmentName = "zpa3.zgwa3mm6002.view.ShBatid";
                    break;
                case "Stoid":
                    sFragmentName = "zpa3.zgwa3mm6002.view.ShStoid";
                    break;
            }

            if (!this["_oSh" + sType]) {
                this["_oSh" + sType] = sap.ui.xmlfragment(sFragmentName, this);
                this.getView().addDependent(this["_oSh" + sType]);
            }

            this["_oSh" + sType].open();
            this._applySearchHelpDefaultFilter(sType);
        },

        _applySearchHelpDefaultFilter: function (sType) {
            var oCondModel = this.getView().getModel("cond");
            var oDialog = this["_oSh" + sType];
            var oBinding = oDialog.getBinding("items");
            var aFilters = [];

            if (!oBinding) {
                return;
            }

            if (sType === "Batid") {
                aFilters.push(new Filter("Matid", FilterOperator.EQ, oCondModel.getProperty("/Matid")));
            }

            if (sType === "Stoid") {
                aFilters.push(new Filter("Plaid", FilterOperator.EQ, oCondModel.getProperty("/Plaid")));
            }

            oBinding.filter(aFilters);
        },

        onShMatidSearch: function (oEvent) {
            this._filterSearchHelp(oEvent, ["Mtext", "Matid"]);
        },

        onShPlaidSearch: function (oEvent) {
            this._filterSearchHelp(oEvent, ["Pname", "Plaid"]);
        },

        onShBatidSearch: function (oEvent) {
            this._filterSearchHelp(oEvent, ["Batid", "Matid"], "Batid");
        },

        onShStoidSearch: function (oEvent) {
            this._filterSearchHelp(oEvent, ["Stoid", "Plaid"], "Stoid");
        },

        _filterSearchHelp: function (oEvent, aFields, sType) {
            var sValue = oEvent.getParameter("value");
            var oBinding = oEvent.getSource().getBinding("items");
            var aFilters = [];
            var aSearchFilters = [];
            var oCondModel = this.getView().getModel("cond");

            if (sType === "Batid") {
                aFilters.push(new Filter("Matid", FilterOperator.EQ, oCondModel.getProperty("/Matid")));
            }

            if (sType === "Stoid") {
                aFilters.push(new Filter("Plaid", FilterOperator.EQ, oCondModel.getProperty("/Plaid")));
            }

            if (sValue) {
                aSearchFilters = aFields.map(function (sField) {
                    return new Filter(sField, FilterOperator.Contains, sValue);
                });

                aFilters.push(new Filter({
                    filters: aSearchFilters,
                    and: false
                }));
            }

            if (oBinding) {
                oBinding.filter(aFilters);
            }
        },

        onShMatidClose: function (oEvent) {
            this._setSearchHelpValue(oEvent, "Matid", "description");
        },

        onShPlaidClose: function (oEvent) {
            this._setSearchHelpValue(oEvent, "Plaid", "description");
        },

        onShBatidClose: function (oEvent) {
            this._setSearchHelpValue(oEvent, "Batid", "title");
        },

        onShStoidClose: function (oEvent) {
            this._setSearchHelpValue(oEvent, "Stoid", "title");
        },

        _setSearchHelpValue: function (oEvent, sField, sValueType) {
            var oSelectedItem = oEvent.getParameter("selectedItem");
            var sValue = "";

            if (oSelectedItem) {
                if (sValueType === "description") {
                    sValue = oSelectedItem.getDescription();
                } else {
                    sValue = oSelectedItem.getTitle();
                }

                this.getView().getModel("cond").setProperty("/" + sField, sValue);
            }

            this._clearSearchHelpFilter(oEvent);
        },

        _clearSearchHelpFilter: function (oEvent) {
            var oBinding = oEvent.getSource().getBinding("items");

            if (oBinding) {
                oBinding.filter([]);
            }
        }

    });
});