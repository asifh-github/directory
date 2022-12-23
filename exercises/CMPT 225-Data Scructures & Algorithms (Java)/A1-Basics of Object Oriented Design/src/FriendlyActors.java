public class FriendlyActors extends Actors{
    private String name = "Ally";
    private int level = 1;

    public FriendlyActors(){}

    public FriendlyActors(String n){
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
        System.out.println("I am " + this.name + ", an ally.");
        System.out.println("Level: " + this.level);
    }

    public void fight(MonsterActors e){
        if (this.level > e.getLevel()){
            System.out.println(this.name + " wins!");
            System.out.println(e.getName() + " is defeated.");
            levelUp();
        }
        else{
            System.out.println(e.getName() + " wins!");
            System.out.println(this.name + " is defeated.");
        }
    }

    public void fight(PlayerActors p){
        System.out.println("Cannot fight Ally or Civilian!");
    }

    public void fight(NeutralActors c){
        System.out.println("Cannot fight Ally or Civilian!");
    }

    public void chat(PlayerActors p){
        System.out.println(this.name + ": I will help you fight the enemy " + p.getName() + ".");
    }
    public void chat(NeutralActors c){
        System.out.println(this.name + ": How are you doing " + c.getName() + "?");
    }
}
