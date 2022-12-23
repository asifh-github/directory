public class Main {
    public static void main(String args[]){
        //creating actors
        PlayerActors p1 = new PlayerActors("Fizz");
        FriendlyActors a1 = new FriendlyActors("Garen");
        FriendlyActors a2 = new FriendlyActors("Lux");
        MonsterActors e1 = new MonsterActors("Darius");
        MonsterActors e2 = new MonsterActors("Draven");
        NeutralActors c1 = new NeutralActors("Priest");
        NeutralActors c2 = new NeutralActors();
        NeutralActors c3 = new NeutralActors("Traveller");

        //all actor's announcement
        p1.myDescription();
        System.out.println("");

        a1.myDescription();
        System.out.println("");

        a2.myDescription();
        System.out.println("");

        e1.myDescription();
        System.out.println("");

        e2.myDescription();
        System.out.println("");

        c1.myDescription();
        System.out.println("");

        c2.myDescription();
        System.out.println("");

        c2.myDescription();
        System.out.println("");

        //player actor's fight
        p1.fight(a1);
        System.out.println("");

        e1.myDescription(p1);
        System.out.println("");
        p1.fight(e1);
        System.out.println("");

        e2.levelUp();
        e2.levelUp();
        e2.myDescription(p1);
        System.out.println("");
        p1.fight(e2);
        System.out.println("");

        p1.fight(c1);
        System.out.println("");

        //player actor's chat
        p1.chat(c3);
        System.out.println("");
        p1.chat(a1);
        System.out.println("");


        //friendly actor's fight
        a2.fight(e1);
        System.out.println("");

        a1.fight(p1);
        System.out.println("");

        //friendly actor's chat
        a1.chat(p1);
        System.out.println("");

        a2.chat(c1);
        System.out.println("");

        //monster actor's fight
        e2.fight(a2);
        System.out.println("");

        e1.fight(p1);
        System.out.println("");

        e1.fight(c3);
        System.out.println("");

        //neutral actor's chat
        c1.chat(p1);
        System.out.println("");

        c2.chat(c3);
    }
}
