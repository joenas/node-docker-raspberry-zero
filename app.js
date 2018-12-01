const express = require('express')
const app = express()
const port = process.env.PORT || 5000

app.get('/*', async (req, res, next) => {
  res.send("hello is there anybody out there?")
})

app.listen(port, () => console.log(`Listening on port ${port}`))
