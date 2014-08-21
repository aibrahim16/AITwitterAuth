AITwitterAuth is a library that is intended to simplify the Authentication process for Twitter

## Usage
<pre><code>[AITwitterAuth authenticateWithCompletionHandler:^(AIAccount *account) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@ has been successfully authenticated.", account.username]);
    } failureHandler:^(NSError *error) {
        NSLog(@"[ERROR]: %@", error.localizedDescription);
    }];</code></pre>

## Podfile
<pre><code>platform :ios, '7.0'
pod "AITwitterAuth", "~> 0.0.2"</code></pre>
