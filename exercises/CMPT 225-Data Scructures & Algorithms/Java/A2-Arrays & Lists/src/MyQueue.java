import java.util.Stack;

class MyQueue {
    private Stack<String> DStack = new Stack<String>();
    private Stack<String> CStack = new Stack<String>();

    public MyQueue(){
    }

    public void enqueue(String s){
        while(!CStack.isEmpty()){
            DStack.push(CStack.pop());
        }
        CStack.push(s);
        while(!DStack.isEmpty()){
            CStack.push(DStack.pop());
        }
    }

    public String dequeue() throws RuntimeException{
        if(CStack.isEmpty()){
            throw new RuntimeException("Q is empty");
        }
        return DStack.push(CStack.pop());
    }
}
