sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast"
], function (Controller, JSONModel, MessageToast) {
    "use strict";

    return Controller.extend("zpa3.zgwa3mm6001.controller.Detail", {

        onInit: function () {
            var oRouter = sap.ui.core.UIComponent.getRouterFor(this);

            oRouter.getRoute("RouteDetail").attachPatternMatched(this._onObjectMatched, this);

            this.getView().setModel(new JSONModel({}), "local");
        },

        _onObjectMatched: function (oEvent) {
            var sMatid = oEvent.getParameter("arguments").matid;

            // 기본 ODataModel
            var oODataModel = this.getView().getModel();

            var sPath = oODataModel.createKey("/esMatDetailSet", {
                Matid: sMatid
            });

            this._onRead(oODataModel, sPath);
        },

        _onRead: function (oODataModel, sPath) {
            var oView = this.getView();
            var oLocalModel = oView.getModel("local");

            oODataModel.read(sPath, {
                success: function (oData) {

                    if (oData.Sflag === "E") {
                        MessageToast.show(oData.Smesg);
                        return;
                    }

                    oLocalModel.setProperty("/matDetail", oData);

                    oView.bindElement({
                        path: "local>/matDetail"
                    });
                },
                error: function () {
                    MessageToast.show("예기치 못한 오류입니다.");
                }
            });
        },

        onNavBack: function () {

            // local 모델 데이터 초기화
            this.getView().getModel("local").setData({});

            // Panel 바인딩 해제
            this.byId("idPanDetail").unbindElement();

            // 뒤로가기
            window.history.back();
        }
    });
});