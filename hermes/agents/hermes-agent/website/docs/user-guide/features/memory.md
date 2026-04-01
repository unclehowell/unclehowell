# Memory

Hermes supports a flexible memory system that allows it to retain context and information across interactions. This is crucial for maintaining coherent conversations and remembering user preferences and past interactions.

## Types of Memory

Hermes utilizes different types of memory:

### Short-term Memory (Context)
This memory holds the immediate conversation history and context. It's volatile and typically cleared after a session or a significant context window limit is reached.

### Long-term Memory (Persistence)
This memory is stored persistently, allowing the agent to recall information across multiple sessions. It can include:
- User preferences
- Learned facts
- Past conversation summaries
- User-provided personal information

## Memory Management

Hermes employs strategies to manage memory efficiently:
- **Summarization:** Long conversations are summarized to fit within context windows.
- **Pruning:** Older or less relevant information may be pruned to free up memory.
- **Vectorization:** Information can be vectorized for efficient similarity search and retrieval.

## Customization

Users can influence memory behavior through configuration. For example, by specifying what kind of information should be remembered or how memory should be accessed.

## Examples

- "Remember that I prefer concise answers." (Short-term, potentially influencing future responses)
- "Recall my previous conversation about setting up a new project." (Long-term memory retrieval)