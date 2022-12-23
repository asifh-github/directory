class Books {
    private String name;
    private String author;
    private boolean flag;
    private int id;

    Books(){
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setFlag(boolean flag) {
        this.flag = flag;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public String getAuthor() {
        return author;
    }

    public boolean isFlag() {
        return flag;
    }

    public int getId() {
        return id;
    }
}
