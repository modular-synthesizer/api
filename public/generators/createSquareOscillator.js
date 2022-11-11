function createSineOscillator(context, name) {
  const node = context.createOscillator();
  node.type = "square"
  return [{name, node}]
}