import express from "express";
import { z } from "zod";

const app = express();
app.use(express.json());

const bodySchema = z.object({
  name: z.string(),
});

app.post("/:id", (req, res) => {
  const result = bodySchema.safeParse(req.body);

  if (!result.success) {
    return res.status(400).json({ error: "Invalid request body" });
  }

  res.json({
    id: req.params.id,
    signature: req.query.signature as string,
    data: `Hello, "${result.data.name}"!`,
  });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Express server running on port ${port}`);
});
