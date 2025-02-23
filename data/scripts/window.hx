import funkin.backend.scripting.events.StateEvent;
function onStateSwitch(event:StateEvent) {
    changeWindowTitle(event.state);
}