sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageBox",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/ui/model/json/JSONModel"
], function (Controller, MessageBox, Filter, FilterOperator, JSONModel) {
    "use strict";

    return Controller.extend("zpa3.zgwa3mm6001.controller.Main", {

        onInit: function () {
            var oBefore14 = new Date();
            oBefore14.setDate(oBefore14.getDate() - 14);
            oBefore14.setHours(0, 0, 0, 0);

            var oToday = new Date();
            oToday.setHours(0, 0, 0, 0);

            var oData = {
                matidLow: "M20080000000001",
                matidHigh: "M20080000000009",
                plaidLow: "",
                plaidHigh: "",
                hsdatLow: oBefore14,
                hsdatHigh: oToday
            };

            this.getView().setModel(new JSONModel(oData), "cond");
        },

        onSearch: function () {
            var oCond = this.getView().getModel("cond").getData();
            var aFilters = [];

            if (!this._validateSearchCond(oCond)) {
                return;
            }

            this._addRangeFilter(aFilters, "Matid", oCond.matidLow, oCond.matidHigh);
            this._addRangeFilter(aFilters, "Plaid", oCond.plaidLow, oCond.plaidHigh);
            this._addRangeFilter(aFilters, "Hsdat", oCond.hsdatLow, oCond.hsdatHigh);

            var oBinding = this.byId("tabIdList").getBinding("items");

            if (oBinding) {
                if (oBinding.isSuspended()) {
                    oBinding.resume();
                }

                oBinding.filter(aFilters);
            }
        },

        _validateSearchCond: function (oCond) {
            var oToday = new Date();
            oToday.setHours(23, 59, 59, 999);

            // 자재번호 Low 필수
            if (!oCond.matidLow) {
                MessageBox.show("자재번호 시작값은 필수입니다.");
                return false;
            }

            // 자재번호 Low > High 체크
            if (oCond.matidHigh && oCond.matidLow > oCond.matidHigh) {
                MessageBox.show("자재번호 시작값은 종료값보다 클 수 없습니다.");
                return false;
            }

            // 플랜트 Low > High 체크
            if (oCond.plaidLow && oCond.plaidHigh && oCond.plaidLow > oCond.plaidHigh) {
                MessageBox.show("플랜트 시작값은 종료값보다 클 수 없습니다.");
                return false;
            }

            // 제조일자 미래일 체크
            if (oCond.hsdatLow && oCond.hsdatLow > oToday) {
                MessageBox.show("제조일자 시작일은 현재일자 이후로 입력할 수 없습니다.");
                return false;
            }

            if (oCond.hsdatHigh && oCond.hsdatHigh > oToday) {
                MessageBox.show("제조일자 종료일은 현재일자 이후로 입력할 수 없습니다.");
                return false;
            }

            // 제조일자 Low > High 체크
            if (oCond.hsdatLow && oCond.hsdatHigh && oCond.hsdatLow > oCond.hsdatHigh) {
                MessageBox.show("제조일자 시작일은 종료일보다 클 수 없습니다.");
                return false;
            }

            return true;
        },

        onReset: function () {
            // 검색조건 빈값 초기화
            this.getView().getModel("cond").setData({
                matidLow: "",
                matidHigh: "",
                plaidLow: "",
                plaidHigh: "",
                hsdatLow: null,
                hsdatHigh: null
            });

            // 테이블 데이터 비우기
            var oTable = this.byId("tabIdList");
            var oBinding = oTable.getBinding("items");

            if (oBinding) {
                // 절대 조회되지 않을 조건으로 필터 적용해서 테이블 비움
                oBinding.filter([
                    new Filter("Matid", FilterOperator.EQ, "__EMPTY__")
                ]);
            }
        },

        onPressMaterial: function (oEvent) {
            var oItem = oEvent.getSource();
            var oContext = oItem.getBindingContext();
            var sMatid = oContext.getProperty("Matid");
            var oRouter = sap.ui.core.UIComponent.getRouterFor(this);

            oRouter.navTo("RouteDetail", {
                matid: sMatid
            });
        },

        onShMatid: function (oEvent) {
            this._sMatidInputId = oEvent.getSource().getId();

            if (!this._oSDMatid) {
                this._oSDMatid = sap.ui.xmlfragment(
                    "zpa3.zgwa3mm6001.view.ShMatid",
                    this
                );
                this.getView().addDependent(this._oSDMatid);
            }

            this._oSDMatid.open();
        },

        onShMatidSearch: function (oEvent) {
            var sSearch = oEvent.getParameter("value");
            var oBinding = oEvent.getSource().getBinding("items");
            var aFilters = [];

            if (sSearch) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("Matid", FilterOperator.Contains, sSearch),
                        new Filter("Mtext", FilterOperator.Contains, sSearch)
                    ],
                    and: false
                }));
            }

            if (oBinding) {
                oBinding.filter(aFilters);
            }
        },

        onShMatidClose: function (oEvent) {
            var oSelectedItem = oEvent.getParameter("selectedItem");

            if (oSelectedItem && this._sMatidInputId) {
                sap.ui.getCore()
                    .byId(this._sMatidInputId)
                    .setValue(oSelectedItem.getDescription());
            }

            this._clearDialogFilter(oEvent);
            this._sMatidInputId = null;
        },

        onShPlaid: function (oEvent) {
            this._sPlaidInputId = oEvent.getSource().getId();

            if (!this._oSDPlaid) {
                this._oSDPlaid = sap.ui.xmlfragment(
                    "zpa3.zgwa3mm6001.view.ShPlaid",
                    this
                );
                this.getView().addDependent(this._oSDPlaid);
            }

            this._oSDPlaid.open();
        },

        onShPlaidSearch: function (oEvent) {
            var sSearch = oEvent.getParameter("value");
            var oBinding = oEvent.getSource().getBinding("items");
            var aFilters = [];

            if (sSearch) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("Plaid", FilterOperator.Contains, sSearch),
                        new Filter("Pname", FilterOperator.Contains, sSearch)
                    ],
                    and: false
                }));
            }

            if (oBinding) {
                oBinding.filter(aFilters);
            }
        },

        onShPlaidClose: function (oEvent) {
            var oSelectedItem = oEvent.getParameter("selectedItem");

            if (oSelectedItem && this._sPlaidInputId) {
                sap.ui.getCore()
                    .byId(this._sPlaidInputId)
                    .setValue(oSelectedItem.getDescription());
            }

            this._clearDialogFilter(oEvent);
            this._sPlaidInputId = null;
        },

        _addRangeFilter: function (aFilters, sField, vLow, vHigh) {
            if (vLow && vHigh) {
                aFilters.push(new Filter(sField, FilterOperator.BT, vLow, vHigh));
            } else if (vLow) {
                aFilters.push(new Filter(sField, FilterOperator.EQ, vLow));
            } else if (vHigh) {
                aFilters.push(new Filter(sField, FilterOperator.EQ, vHigh));
            }
        },

        _checkDate: function (oDate) {
            if (!oDate) {
                return true;
            }

            var oToday = new Date();
            oToday.setHours(23, 59, 59, 999);

            return oDate <= oToday;
        },

        _clearDialogFilter: function (oEvent) {
            var oBinding = oEvent.getSource().getBinding("items");

            if (oBinding) {
                oBinding.filter([]);
            }
        }

    });
});