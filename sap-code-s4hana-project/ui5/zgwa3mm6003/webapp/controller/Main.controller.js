sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/SelectDialog",
    "sap/m/StandardListItem"
], function (Controller, JSONModel, Filter, FilterOperator, SelectDialog, StandardListItem) {
    "use strict";

    return Controller.extend("zpa3.zgwa3mm6003.controller.Main", {

        onInit: function () {
            this.getView().setModel(new JSONModel(this._getCondInitData()), "cond");
            this._setChartProperties();
        },

        _getCondInitData: function () {
            return {
                Matid: "",
                Plaid: "",
                Batid: ""
            };
        },

        _setChartProperties: function () {
            var oChart = this.byId("idExpChart");

            if (!oChart) {
                return;
            }

            oChart.setVizProperties({
                title: {
                    visible: true,
                    text: "유통기한 상태별 재고"
                },
                plotArea: {
                    dataLabel: {
                        visible: true,
                        type: "value"
                    }
                },
                legend: {
                    visible: true
                }
            });
        },

        onSearch: function () {
            var oCond = this.getView().getModel("cond").getData();
            var aFilters = [];

            this._addEqFilter(aFilters, "Matid", oCond.Matid);
            this._addEqFilter(aFilters, "Plaid", oCond.Plaid);
            this._addEqFilter(aFilters, "Batid", oCond.Batid);

            var oBinding = this.byId("idExpTable").getBinding("items");

            if (oBinding) {
                if (oBinding.isSuspended()) {
                    oBinding.resume();
                }

                oBinding.filter(aFilters);
            }
        },

        onReset: function () {
            this.getView().getModel("cond").setData(this._getCondInitData());

            var oBinding = this.byId("idExpTable").getBinding("items");

            if (oBinding) {
                oBinding.filter([
                    new Filter("Matid", FilterOperator.EQ, "__EMPTY__")
                ]);
            }
        },

        onShMatid: function () {
            this._openValueHelp({
                title: "자재번호 선택",
                path: "/esMatSet",
                keyField: "Matid",
                descField: "Mtext",
                targetField: "Matid",
                searchFields: ["Mtext"],
                baseFilters: []
            });
        },

        onShPlaid: function () {
            this._openValueHelp({
                title: "플랜트 선택",
                path: "/esPlaSet",
                keyField: "Plaid",
                descField: "Pname",
                targetField: "Plaid",
                searchFields: ["Pname"],
                baseFilters: []
            });
        },

        onShBatid: function () {
            var oCond = this.getView().getModel("cond").getData();
            var aBaseFilters = [];

            if (oCond.Matid) {
                aBaseFilters.push(
                    new Filter("Matid", FilterOperator.EQ, oCond.Matid)
                );
            }

            this._openValueHelp({
                title: "배치번호 선택",
                path: "/esBatSet",
                keyField: "Batid",
                descField: "Hsdat",
                targetField: "Batid",
                searchFields: ["Batid"],
                baseFilters: aBaseFilters
            });
        },

        _openValueHelp: function (mConfig) {
            var oCondModel = this.getView().getModel("cond");

            var oDialog = new SelectDialog({
                title: mConfig.title,
                noDataText: "조회된 데이터가 없습니다.",

                search: function (oEvent) {
                    this._onValueHelpSearch(oEvent, mConfig);
                }.bind(this),

                liveChange: function (oEvent) {
                    this._onValueHelpSearch(oEvent, mConfig);
                }.bind(this),

                confirm: function (oEvent) {
                    var oSelectedItem = oEvent.getParameter("selectedItem");

                    if (!oSelectedItem) {
                        return;
                    }

                    oCondModel.setProperty(
                        "/" + mConfig.targetField,
                        oSelectedItem.getTitle()
                    );
                },

                afterClose: function () {
                    oDialog.destroy();
                }
            });

            oDialog.setModel(this.getView().getModel());

            oDialog.bindAggregation("items", {
                path: mConfig.path,
                filters: mConfig.baseFilters,
                template: new StandardListItem({
                    title: "{" + mConfig.keyField + "}",
                    description: "{" + mConfig.descField + "}"
                })
            });

            oDialog.open();
        },

        _onValueHelpSearch: function (oEvent, mConfig) {
            var sValue = oEvent.getParameter("value");
            var oBinding = oEvent.getSource().getBinding("items");
            var aBaseFilters = mConfig.baseFilters || [];
            var aSearchFilters = [];
            var aFinalFilters = [];

            if (sValue) {
                for (var i = 0; i < mConfig.searchFields.length; i++) {
                    aSearchFilters.push(
                        new Filter(mConfig.searchFields[i], FilterOperator.Contains, sValue)
                    );
                }
            }

            if (aBaseFilters.length > 0) {
                aFinalFilters.push(
                    new Filter({
                        filters: aBaseFilters,
                        and: true
                    })
                );
            }

            if (aSearchFilters.length > 0) {
                aFinalFilters.push(
                    new Filter({
                        filters: aSearchFilters,
                        and: false
                    })
                );
            }

            if (aFinalFilters.length > 0) {
                oBinding.filter([
                    new Filter({
                        filters: aFinalFilters,
                        and: true
                    })
                ]);
            } else {
                oBinding.filter([]);
            }
        },

        _addEqFilter: function (aFilters, sField, vValue) {
            if (vValue) {
                aFilters.push(new Filter(sField, FilterOperator.EQ, vValue));
            }
        }

    });
});