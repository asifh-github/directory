"use strict";
class DejimonTracker {
    constructor() {
        this.dejimonArr = [];
    }
    getSize() {
        return DejimonTracker.uniqueID;
    }
    add(d) {
        d.id = DejimonTracker.uniqueID;
        DejimonTracker.uniqueID++;
        this.dejimonArr.push(d);
        console.log(" ");
        console.log("Added: " + JSON.stringify(d));
    }
    remove(index) {
        if (index == null) {
            console.log("Invalid..");
            return;
        }
        console.log(" ");
        console.log("Removed: " + this.dejimonArr[index]);
        this.dejimonArr.splice(index, 1);
    }
    info(index) {
        console.log(" ");
        console.log("Info: ");
        return this.dejimonArr[index];
    }
}
DejimonTracker.uniqueID = 0;
