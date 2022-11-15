const node = context.createOscillator();
node.type = "sine"
node.start();
return [{name, node}]