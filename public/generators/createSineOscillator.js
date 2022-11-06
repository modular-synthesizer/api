function createSineOscillator(context, name) {
  const node = context.createOscillator();
  node.type = "sine"
  return [{name, node}]
}