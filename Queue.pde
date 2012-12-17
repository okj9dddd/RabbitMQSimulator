class Queue extends Node implements IConnectable {
  int type = QUEUE;
  ArrayList messages = new ArrayList();  
  
  Queue(String name, float x, float y) {
    super(name, colors[QUEUE], x, y);
  }
  
  int getType() {
    return type;
  }
  
  boolean accepts(Node n) {
    return n.getType() == CONSUMER;
  }
  
  boolean canStartConnection() {
    return true;
  }
  
  void connectWith(Node n, int endpoint) {
    super.connectWith(n, endpoint);
    maybeDeliverMessage();
  }
  
  void trasnferArrived(Transfer transfer) {
    enqueue(transfer);
    maybeDeliverMessage();
  }
  
  void transferDelivered(Transfer transfer) {
    incoming.add(transfer.getTo());
    maybeDeliverMessage();
  }
  
  void enqueue(Transfer transfer) {
    messages.add(transfer);
  }
  
  Transfer dequeue() {
    return (Transfer) messages.remove(0);
  }
  
  void maybeDeliverMessage() {
    if (messages.size() > 0) {
      if (incoming.size() > 0) {
        Node consumer = (Node) incoming.remove(0);
        Transfer transfer = dequeue();
        stage.addTransfer(new Transfer(stage, this, consumer, transfer.getData()));
      }
    }
  }
  
  void draw() {
    super.draw();
    
    // draw queue depth text
    fill (0);
    textAlign(CENTER, CENTER);
    text(str(messages.size()), x + radii + 5, y - radii - 5);
  }
}
