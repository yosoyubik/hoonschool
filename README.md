# Hoon School

# Hoon 101

`%/hoon101`

Copy all files inside the `%/gen` folder and `|commit %base` manually.

# Hoon 201
`%/hoon201`
## Using

First you need to create a file called `.urbitrc`

```
module.exports = {
  URBIT_PIERS: [
    "<PATH_TO_YOUR_URBIT>/base",
  ]
};
```

`npm run serve`

Watches the assignment folder located in `%/hoon201/assignments` and syncs all files it into your Urbit ship's folder.

After the files have been copied or modifed, run `|commit %base` to sync them with clay.
