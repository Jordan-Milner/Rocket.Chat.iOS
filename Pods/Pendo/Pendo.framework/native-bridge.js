function getFromContext(context, name) {
  return context[name];
}

function getOrientation() {
  var orientation = IIOInsertNativeBridge.getDeviceOrientation();
  return orientation;
}

function logD(msg) {
  IIOInsertNativeBridge.log(msg);
};

function StandIn(id) {
  this.elementId = id;
};

function getGuideStepId(context) {
  return getFromContext(context, 'guideStepId')
}

function gaTracker(trackingId) {
  return IIOInsertNativeBridge.gaTracker(trackingId);
}

function gaScreenView(screenName, tracker) {
  return IIOInsertNativeBridge.gaScreenViewTracker(screenName, tracker);
}

function gaTapOn(elementName, tracker) {
  return IIOInsertNativeBridge.gaTapOnTracker(elementName, tracker);
}

StandIn.prototype.getPageNumber = function () {
  return IIOInsertNativeBridge.getPageNumber(this.elementId);
};

StandIn.prototype.getAnswers = function () {

  var d = IIOInsertNativeBridge.getAnswers(this.elementId);
  var c = d['additionalInfo'];
  return c;
};

StandIn.prototype.isValid = function () {
  return IIOInsertNativeBridge.isValid(this.elementId);
};

var dispatchActions = function (actions, context) {
  IIOInsertNativeBridge.dispatchActionsContext(actions, context);
};

var dispatchTriggerActions = function (actions, context) {
  IIOInsertNativeBridge.dispatchTriggerActionsContext(actions, context);
};

var findElementById = function (id) {
  return new StandIn(id);
};

function getActiveTimeGuideDismissed(context) {
  return getFromContext(context, 'insertActiveTime');
}

function sumAllActiveTimes(activeTimes) {
  var sum = 0;
  for (n in activeTimes) {
    sum += activeTimes[n].duration;
  }
  return sum;
}

function getDurationGuideDismissed(context) {
  var activeTimes = getActiveTimeGuideDismissed(context);
  var sum = sumAllActiveTimes(activeTimes);
  return sum.toString();
}

function getActiveTimeForAppSessionEnd() {
  return "STUB";
}

function getActiveTimeFromLastForeground() {
  return "STUB";
}

function getActiveTimeScreenLeft(context) {
  return getFromContext(context, 'screenActiveTime');
}

function getDurationAppInBackground() {
  return "STUB";
}

function getDurationScreenLeft(context) {
  var activeTimes = getActiveTimeScreenLeft(context);
  var sum = sumAllActiveTimes(activeTimes);
  return sum.toString();
}

function getDurationSessionEnd() {
  return "STUB";
}

function guideRun(context) {
}
