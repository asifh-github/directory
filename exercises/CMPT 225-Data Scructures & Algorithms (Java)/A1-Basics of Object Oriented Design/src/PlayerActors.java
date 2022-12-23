public class PlayerActors extends Actors {
    private String name = "Player";
    private int level = 1;

    public PlayerActors(){}

    public PlayerActors(String n){
        this.name = n;
    }

    public String getName(){
        return name;
    }
    public void levelUp(){
        this.level++;
        System.out.println("Level up!");
        System.out.println("Level: " + this.level);
    }

    public int getLevel() {
        return level;
    }

    public void myDescription(){
        System.out.println("I am " + this.name + ", the player.");
        System.out.println("Level: " + this.level);
    }

    public void fight(MonsterActors e){
        if (this.level >= e.getLevel()){
            System.out.println(this.name + " wins!");
            System.out.println(e.getName() + " is defeated.");
            levelUp();
        }
        else{
            System.out.println(e.getName() + " wins!");
            System.out.println(this.name + " is defeated.");
        }
    }

    public void fight(FriendlyActors a){
        System.out.println("You cannot fight Ally or Civilian!");
    }
    public void fight(NeutralActors c){
        System.out.println("You cannot fight Ally or Civilian!");
    }

    public void chat(FriendlyActors a){
        System.out.println(this.name + ": Help me fight the enemy.. " + a.getName());

    }

    public void chat(NeutralActors c){
        System.out.println(this.name + ": How is your day " + c.getName() + "?");
    }
}
