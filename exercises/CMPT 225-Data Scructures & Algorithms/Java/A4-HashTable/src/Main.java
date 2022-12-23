import java.security.InvalidKeyException;

class Main {
    public static void main(String args[]) throws InvalidKeyException {
        // ---problem 2.1---
        System.out.println("---Problem 2.1---");

        // creates student entries
        System.out.println(" ");
        System.out.println("***Creating 6 student entries...***");
        StudentEntry s1 = new StudentEntry("Sanji", "Vinsmoke", "Culinary", 1996, new ContactInfo(77825159, "vsgerma663@gmail.com"));
        StudentEntry s2 = new StudentEntry("Zoro", "Roronoa", "Swordsmanship", 1995, new ContactInfo(25179131, "worldsgreatestswordsman@gmail.com"));
        StudentEntry s3 = new StudentEntry("Chopper", "Tony", "Medicine", 2000, new ContactInfo(77825123, "cookingmeds@hotmail.com"));
        StudentEntry s4 = new StudentEntry("Robin", "Nico", "History", 1995, new ContactInfo(66782005, "red_ponygliffs4@gmail.com"));
        StudentEntry s5 = new StudentEntry("Luffy", "Monkey D.", "Humanities", 1999, new ContactInfo(10177899, "kingofthepirates@yahoo.com"));
        StudentEntry s6 = new StudentEntry("Nami", "Nami", "Navigation", 1998, new ContactInfo(23346900, "catburglar@yahoo.com"));
        System.out.println("(s1, s2, s3, s4, s5, s6)");

        // creates hash table
        System.out.println(" ");
        System.out.println("***Creating hash table...***");
        MyHashTable<String, StudentEntry> ht = new MyHashTable<String, StudentEntry>(6);

//        // demo: generates hash keys
//        System.out.println(" ");
//        System.out.println("***Demo: Generating hash keys for student entries w/o load factor...***");
//        System.out.println("s1: " + ht.hashFunction(s1.key()));
//        System.out.println("s2: " + ht.hashFunction(s2.key()));
//        System.out.println("s3: " + ht.hashFunction(s3.key()));
//        System.out.println("s4: " + ht.hashFunction(s4.key()));
//        System.out.println("s5: " + ht.hashFunction(s5.key()));
//        System.out.println("s6: " + ht.hashFunction(s6.key()));

        // adds entries to hash table
        System.out.println(" ");
        System.out.println("***Adding all 6 entries to bucket array (hash table)...***");
        ht.addEntry(s1.key_1(), s1);
        ht.addEntry(s2.key_1(), s2);
        ht.addEntry(s3.key_1(), s3);
        ht.addEntry(s4.key_1(), s4);
        ht.addEntry(s5.key_1(), s5);
        ht.addEntry(s6.key_1(), s5);

        // gets number of collisions
        System.out.println(" ");
        System.out.println("Collisions: " + ht.collisions());

        // gets entries from hash table
        System.out.println(" ");
        System.out.println("***Getting all 6 entries from bucket array (hash table)...***");
        System.out.println(ht.getEntry(s1.key_1()));
        System.out.println(ht.getEntry(s2.key_1()));
        System.out.println(ht.getEntry(s3.key_1()));
        System.out.println(ht.getEntry(s4.key_1()));
        System.out.println(ht.getEntry(s5.key_1()));
        System.out.println(ht.getEntry(s6.key_1()));
        System.out.println(" ");
        System.out.println("Size: " + ht.getSize());

        // removes entries from hash table
        System.out.println(" ");
        System.out.println("***Removing 3 entries from bucket array (hash table)...***");
        ht.removeEntry(s2.key_1());
        ht.removeEntry(s3.key_1());
        ht.removeEntry(s5.key_1());

        // gets entries from hash table
        System.out.println(" ");
        System.out.println("***Getting all 6 entries from bucket array (hash table)...***");
        System.out.println(ht.getEntry(s1.key_1()));
        System.out.println(ht.getEntry(s2.key_1()));
        System.out.println(ht.getEntry(s3.key_1()));
        System.out.println(ht.getEntry(s4.key_1()));
        System.out.println(ht.getEntry(s5.key_1()));
        System.out.println(ht.getEntry(s6.key_1()));
        System.out.println(" ");
        System.out.println("Size: " + ht.getSize());

        // gets entry from hash table and prints it
        System.out.println(" ");
        System.out.println("***Getting s1 from bucket array (hash table) and printing it...***");
        StudentEntry temp_1 = ht.getEntry(s1.key_1());
        System.out.println("(s1)");
        temp_1.print();

        // removes entry from hash table and prints it
        System.out.println(" ");
        System.out.println("***Removing s6 from bucket array (hash table) and printing it...***");
        StudentEntry temp_2 = ht.removeEntry(s6.key_1());
        System.out.println("(s6)");
        temp_2.print();

        // removes entries from hash table
        System.out.println(" ");
        System.out.println("***Removing remaining entries from bucket array (hash table)...***");
        ht.removeEntry(s1.key_1());
        ht.removeEntry(s4.key_1());

        // gets entries from hash table
        System.out.println(" ");
        System.out.println("***Getting all 6 entries from bucket array (hash table)...***");
        System.out.println(ht.getEntry(s1.key_1()));
        System.out.println(ht.getEntry(s2.key_1()));
        System.out.println(ht.getEntry(s3.key_1()));
        System.out.println(ht.getEntry(s4.key_1()));
        System.out.println(ht.getEntry(s5.key_1()));
        System.out.println(ht.getEntry(s6.key_1()));
        System.out.println(" ");
        System.out.println("Size: " + ht.getSize());


        //---problem 2.2---
        System.out.println(" ");
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---Problem 2.2---");

        // creates student entries
        StudentEntry e1 = new StudentEntry("John", "Smith", "Computer Science", 1988, new ContactInfo(5555555, "jsmith@email.com"));
        StudentEntry e2 = new StudentEntry("Howard", "Calico", "Chemical Engineering", 1991, new ContactInfo(8675309, "hcalico@email.com"));
        StudentEntry e3 = new StudentEntry("Yarah", "Bahri", "Psychology", 1976, new ContactInfo(6647665, "ybahri@email.com"));
        StudentEntry e4 = new StudentEntry("Aveline", "Macon", "Arts", 1991, new ContactInfo(7181234, "its_aveline@avelineworld.com"));
        StudentEntry e5 = new StudentEntry("Pratik", "Gera", "Psychology", 1996, new ContactInfo(3232368, "pgera@email.com"));
        StudentEntry e6 = new StudentEntry("Usui", "Aimi", "Psychology", 1996, new ContactInfo(4623457, "x_shadow_hunter_x03@gaming.com"));
        StudentEntry e7 = new StudentEntry("Jane", "Smith", "Computer Science", 1990, new ContactInfo(5555555, "j2smith@email.com"));
        StudentEntry e8 = new StudentEntry("Vreni", "Spitz", "Law", 1992, new ContactInfo(5554444, "vspitz@email.com"));
        StudentEntry e9 = new StudentEntry("Pratik", "Comar", "Business", 1991, new ContactInfo(6645622, "pcomar@email.com"));
        StudentEntry e10 =  new StudentEntry("Padma", "Gera", "Arts", 1994, new ContactInfo(5554544, "pgera@realemail.org"));

        // creates hash table
        MyHashTable<String, StudentEntry> hashTable_1 = new MyHashTable<>(10);

        // ~~~adds entries to hash table using key 1, hash 1~~~
        System.out.println(" ");
        System.out.println("*****Key 1, Hash 1*****");
        hashTable_1.addEntry(e1.key_1(), e1);
        hashTable_1.addEntry(e2.key_1(), e2);
        hashTable_1.addEntry(e3.key_1(), e3);
        hashTable_1.addEntry(e4.key_1(), e4);
        hashTable_1.addEntry(e5.key_1(), e5);
        hashTable_1.addEntry(e6.key_1(), e6);
        hashTable_1.addEntry(e7.key_1(), e7);
        hashTable_1.addEntry(e8.key_1(), e8);
        hashTable_1.addEntry(e9.key_1(), e9);
        hashTable_1.addEntry(e10.key_1(), e10);

        // prints capacity, size & number of collisions, rehash, free buckets & filled buckets
        System.out.println(" ");
        System.out.println("Capacity: " + hashTable_1.getCapacity());
        System.out.println(" ");
        System.out.println("Size: " + hashTable_1.getSize());
        System.out.println(" ");
        System.out.println("Collisions: " + hashTable_1.collisions());
        System.out.println(" ");
        System.out.println("Rehash: " + hashTable_1.n_Rehash());
        System.out.println(" ");
        System.out.println("Free buckets: " + hashTable_1.free());
        System.out.println(" ");
        System.out.println("Occupied buckets: " + hashTable_1.occupied());

        // prints number of entries in longest chain in one bucket
        System.out.println(" ");
        System.out.println("Longest chain: " + hashTable_1.n_LongestChain());

        // empties all buckets
        System.out.println(" ");
        System.out.println("Emptying all buckets...");
        hashTable_1.removeEntry(e1.key_1());
        hashTable_1.removeEntry(e2.key_1());
        hashTable_1.removeEntry(e3.key_1());
        hashTable_1.removeEntry(e4.key_1());
        hashTable_1.removeEntry(e5.key_1());
        hashTable_1.removeEntry(e6.key_1());
        hashTable_1.removeEntry(e7.key_1());
        hashTable_1.removeEntry(e8.key_1());
        hashTable_1.removeEntry(e9.key_1());
        hashTable_1.removeEntry(e10.key_1());
        System.out.println("Size: " + hashTable_1.getSize());

        // creates hash table
        MyHashTable<String, StudentEntry> hashTable_12 = new MyHashTable<>(10);

        // ~~~adds entries to hash table using key 1, hash 2~~~
        System.out.println(" ");
        System.out.println("*****Key 1, Hash 2*****");
        hashTable_12.addEntry_2(e1.key_1(), e1);
        hashTable_12.addEntry_2(e2.key_1(), e2);
        hashTable_12.addEntry_2(e3.key_1(), e3);
        hashTable_12.addEntry_2(e4.key_1(), e4);
        hashTable_12.addEntry_2(e5.key_1(), e5);
        hashTable_12.addEntry_2(e6.key_1(), e6);
        hashTable_12.addEntry_2(e7.key_1(), e7);
        hashTable_12.addEntry_2(e8.key_1(), e8);
        hashTable_12.addEntry_2(e9.key_1(), e9);
        hashTable_12.addEntry_2(e10.key_1(), e10);

        // prints capacity, size & number of collisions, rehash, free buckets & filled buckets
        System.out.println(" ");
        System.out.println("Capacity(2): " + hashTable_12.getCapacity());
        System.out.println(" ");
        System.out.println("Size(2): " + hashTable_12.getSize());
        System.out.println(" ");
        System.out.println("Collisions(2): " + hashTable_12.collisions());
        System.out.println(" ");
        System.out.println("Rehash(2): " + hashTable_12.n_Rehash());
        System.out.println(" ");
        System.out.println("Free buckets(2): " + hashTable_12.free());
        System.out.println(" ");
        System.out.println("Occupied buckets(2): " + hashTable_12.occupied());

        // prints number of entries in longest chain in one bucket
        System.out.println(" ");
        System.out.println("Longest chain(2): " + hashTable_12.n_LongestChain());

        // empties all buckets
        System.out.println(" ");
        System.out.println("Emptying all buckets...");
        hashTable_12.removeEntry_2(e1.key_1());
        hashTable_12.removeEntry_2(e2.key_1());
        hashTable_12.removeEntry_2(e3.key_1());
        hashTable_12.removeEntry_2(e4.key_1());
        hashTable_12.removeEntry_2(e5.key_1());
        hashTable_12.removeEntry_2(e6.key_1());
        hashTable_12.removeEntry_2(e7.key_1());
        hashTable_12.removeEntry_2(e8.key_1());
        hashTable_12.removeEntry_2(e9.key_1());
        hashTable_12.removeEntry_2(e10.key_1());
        System.out.println("Size(2): " + hashTable_12.getSize());


        // creates hash table
        MyHashTable<String, StudentEntry> hashTable_2 = new MyHashTable<>(10);

        // ~~~adds entries to hash table using key 2, hash 1~~~
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("*****Key 2, Hash 1*****");
        hashTable_2.addEntry(e1.key_2(), e1);
        hashTable_2.addEntry(e2.key_2(), e2);
        hashTable_2.addEntry(e3.key_2(), e3);
        hashTable_2.addEntry(e4.key_2(), e4);
        hashTable_2.addEntry(e5.key_2(), e5);
        hashTable_2.addEntry(e6.key_2(), e6);
        hashTable_2.addEntry(e7.key_2(), e7);
        hashTable_2.addEntry(e8.key_2(), e8);
        hashTable_2.addEntry(e9.key_2(), e9);
        hashTable_2.addEntry(e10.key_2(), e10);

        // prints capacity, size & number of collisions, rehash, free buckets & filled buckets
        System.out.println(" ");
        System.out.println("Capacity: " + hashTable_2.getCapacity());
        System.out.println(" ");
        System.out.println("Size: " + hashTable_2.getSize());
        System.out.println(" ");
        System.out.println("Collisions: " + hashTable_2.collisions());
        System.out.println(" ");
        System.out.println("Rehash: " + hashTable_2.n_Rehash());
        System.out.println(" ");
        System.out.println("Free buckets: " + hashTable_2.free());
        System.out.println(" ");
        System.out.println("Occupied buckets: " + hashTable_2.occupied());

        // prints number of entries in longest chain in one bucket
        System.out.println(" ");
        System.out.println("Longest chain: " + hashTable_2.n_LongestChain());

        // creates hash table
        MyHashTable<String, StudentEntry> hashTable_22 = new MyHashTable<>(10);

        // ~~~adds entries to hash table using key 2, hash 2~~~
        System.out.println(" ");
        System.out.println("*****Key 2, Hash 2*****");
        hashTable_22.addEntry_2(e1.key_2(), e1);
        hashTable_22.addEntry_2(e2.key_2(), e2);
        hashTable_22.addEntry_2(e3.key_2(), e3);
        hashTable_22.addEntry_2(e4.key_2(), e4);
        hashTable_22.addEntry_2(e5.key_2(), e5);
        hashTable_22.addEntry_2(e6.key_2(), e6);
        hashTable_22.addEntry_2(e7.key_2(), e7);
        hashTable_22.addEntry_2(e8.key_2(), e8);
        hashTable_22.addEntry_2(e9.key_2(), e9);
        hashTable_22.addEntry_2(e10.key_2(), e10);

        // prints capacity, size & number of collisions, rehash, free buckets & filled buckets
        System.out.println(" ");
        System.out.println("Capacity(2): " + hashTable_22.getCapacity());
        System.out.println(" ");
        System.out.println("Size(2): " + hashTable_22.getSize());
        System.out.println(" ");
        System.out.println("Collisions(2): " + hashTable_22.collisions());
        System.out.println(" ");
        System.out.println("Rehash(2): " + hashTable_22.n_Rehash());
        System.out.println(" ");
        System.out.println("Free buckets(2): " + hashTable_22.free());
        System.out.println(" ");
        System.out.println("Occupied buckets(2): " + hashTable_22.occupied());

        // prints number of entries in longest chain in one bucket
        System.out.println(" ");
        System.out.println("Longest chain(2): " + hashTable_22.n_LongestChain());


        // creates hash table
        MyHashTable<String, StudentEntry> hashTable_3 = new MyHashTable<>(10);

        // adds entries to hash table using key 3, hash 1
        System.out.println(" ");
        System.out.println(" ");
        System.out.println("*****Key 3, Hash 1*****");
        hashTable_3.addEntry(e1.key_3(), e1);
        hashTable_3.addEntry(e2.key_3(), e2);
        hashTable_3.addEntry(e3.key_3(), e3);
        hashTable_3.addEntry(e4.key_3(), e4);
        hashTable_3.addEntry(e5.key_3(), e5);
        hashTable_3.addEntry(e6.key_3(), e6);
        hashTable_3.addEntry(e7.key_3(), e7);
        hashTable_3.addEntry(e8.key_3(), e8);
        hashTable_3.addEntry(e9.key_3(), e9);
        hashTable_3.addEntry(e10.key_3(), e10);

        // prints capacity, size & number of collisions, rehash, free buckets & filled buckets
        System.out.println(" ");
        System.out.println("Capacity: " + hashTable_3.getCapacity());
        System.out.println(" ");
        System.out.println("Size: " + hashTable_3.getSize());
        System.out.println(" ");
        System.out.println("Collisions: " + hashTable_3.collisions());
        System.out.println(" ");
        System.out.println("Rehash: " + hashTable_3.n_Rehash());
        System.out.println(" ");
        System.out.println("Free buckets: " + hashTable_3.free());
        System.out.println(" ");
        System.out.println("Occupied buckets: " + hashTable_3.occupied());

        // prints number of entries in longest chain in one bucket
        System.out.println(" ");
        System.out.println("Longest chain: " + hashTable_3.n_LongestChain());

        // creates hash table
        MyHashTable<String, StudentEntry> hashTable_32 = new MyHashTable<>(10);

        // ~~~adds entries to hash table using key 3, hash 2~~~
        System.out.println(" ");
        System.out.println("*****Key 3, Hash 2*****");
        hashTable_32.addEntry_2(e1.key_3(), e1);
        hashTable_32.addEntry_2(e2.key_3(), e2);
        hashTable_32.addEntry_2(e3.key_3(), e3);
        hashTable_32.addEntry_2(e4.key_3(), e4);
        hashTable_32.addEntry_2(e5.key_3(), e5);
        hashTable_32.addEntry_2(e6.key_3(), e6);
        hashTable_32.addEntry_2(e7.key_3(), e7);
        hashTable_32.addEntry_2(e8.key_3(), e8);
        hashTable_32.addEntry_2(e9.key_3(), e9);
        hashTable_32.addEntry_2(e10.key_3(), e10);

        // prints capacity, size & number of collisions, rehash, free buckets & filled buckets
        System.out.println(" ");
        System.out.println("Capacity(2): " + hashTable_32.getCapacity());
        System.out.println(" ");
        System.out.println("Size(2): " + hashTable_32.getSize());
        System.out.println(" ");
        System.out.println("Collisions(2): " + hashTable_32.collisions());
        System.out.println(" ");
        System.out.println("Rehash(2): " + hashTable_32.n_Rehash());
        System.out.println(" ");
        System.out.println("Free buckets(2): " + hashTable_32.free());
        System.out.println(" ");
        System.out.println("Occupied buckets(2): " + hashTable_32.occupied());

        // prints number of entries in longest chain in one bucket
        System.out.println(" ");
        System.out.println("Longest chain(2): " + hashTable_32.n_LongestChain());


        System.out.println(" ");
        System.out.println(" ");
        System.out.println("---End---");
    }
}
