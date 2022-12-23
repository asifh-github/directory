interface Tracker {
    add(d: Dejimon): void;
    remove(index: number): void;
    info(index: number): Dejimon;
}

class DejimonTracker implements Tracker {
    dejimonArr: Dejimon[];
    private static uniqueID = 0;

    constructor(){
        this.dejimonArr = [];
    }
    public getSize(){
        return DejimonTracker.uniqueID;
    }
    public add(d: Dejimon){
        d.id = DejimonTracker.uniqueID;
        DejimonTracker.uniqueID++;
        this.dejimonArr.push(d);
        console.log(" ");
        console.log("Added: " + JSON.stringify(d));
    }
    public remove(index: number){  
        if(index == null){
            console.log("Invalid..");
            return;
        }
        console.log(" ");
        console.log("Removed: " + this.dejimonArr[index]);
        this.dejimonArr.splice(index, 1);
    }
    public info(index: number){
        console.log(" ");
        console.log("Info: ");
        return this.dejimonArr[index];
    }
}