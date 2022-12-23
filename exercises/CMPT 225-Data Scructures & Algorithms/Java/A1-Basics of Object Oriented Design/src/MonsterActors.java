public class MonsterActors extends Actors{
    private String name = "Enemy";
    private int level = 1;

    public MonsterActors(){}

    public MonsterActors(String n){
        this.name = n;
    }

    public String getName(){
        return name;
    }

    public void levelUp(){
        this.level++;
    }

    public int getLevel() {
        return level;
    }

    public void myDescription(){
        System.out.println("I am " + this.name + ", an enemy.");
        System.out.println("Level: " + this.level);
    }

    public void myDescription(PlayerActors p){
        if (this.level > p.getLevel()){
            System.out.println(this.name + ": I challenge you to fight me..");
        }
        else{
            System.out.println(this.name + ": I will fight you..");
        }
        System.out.println("Level: " + this.level);
    }

    public void fight(PlayerActors p){
        if (this.level > p.getLevel()){
            System.out.println(this.name + " wins!");
            System.out.println(p.getName() + " is defeated.");
        }
        else{
            System.out.println(p.getName() + " wins!");
            System.out.println(this.name + " is defeated.");
            p.levelUp();
        }
    }

    public void fight(FriendlyActors a){
        if (this.level >= a.getLevel()){
            System.out.println(this.name + " wins!");
            System.out.println(a.getName() + " is defeated.");
        }
        else{
            System.out.println(a.getName() + " wins!");
            System.out.println(this.name + " is defeated.");
            a.levelUp();
        }
    }

    public void fight(NeutralActors c){
        System.out.println("Cannot fight Civilian!");
    }
}
