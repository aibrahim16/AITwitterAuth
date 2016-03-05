AITwitterAuth is a library that is intended to simplify the Authentication process for Twitter

## Usage
```Objective-C
[AITwitterAuth authenticateWithCompletionHandler:^(AIAccount *account) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@ has been successfully authenticated.", account.username]);
    } failureHandler:^(NSError *error) {
        NSLog(@"[ERROR]: %@", error.localizedDescription);
    }];
```

```Swift

@IBAction func connectTwitter(sender: UIButton) {
        AITwitterAuth.authenticateWithCompletionHandler(twitterLogged, failureHandler: twitterError)
    }
    
    func twitterLogged(account: AIAccount!) {
        println(account.username)
    }
    
    func twitterError(error: NSError!) {
        println(error.localizedDescription)
    }


```

## Podfile
```Pod
platform :ios, '7.0'
pod "AITwitterAuth", "~> 0.0.5"
```
