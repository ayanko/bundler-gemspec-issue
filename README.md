## Overview

According to https://bundler.io/man/bundle-install.1.html#CONSERVATIVE-UPDATING

> When you make a change to the Gemfile(5) and then run bundle install, Bundler will update only the gems that you modified.
>
> In other words, if a gem that you did not modify worked before you called bundle install, it will continue to use the exact same versions of all dependencies as it used before the update.

But it's NOT TRUE if you define gems in gemspec and use `gempsec` or `path` bundler DSL.

## Case1: Classic

```
$ cd classic
```

### Ensure current Gemfile.lock is correct

```
$ bundle install

Using bundler 2.1.4
Using concurrent-ruby 1.1.6
Using i18n 1.8.5
Bundle complete! 1 Gemfile dependency, 3 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

```
$ git diff
(EMPTY)
```

### Adding new gem to gemspec

```
$ WITH_NEW_GEM=1 bundle install

Fetching gem metadata from https://rubygems.org/...
Resolving dependencies...
Using bundler 2.1.4
Using concurrent-ruby 1.1.6
Using deep_merge 1.2.1
Using i18n 1.8.5
Bundle complete! 2 Gemfile dependencies, 4 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

```
--- a/classic/Gemfile.lock
+++ b/classic/Gemfile.lock
@@ -2,6 +2,7 @@ GEM
   remote: https://rubygems.org/
   specs:
     concurrent-ruby (1.1.6)
+    deep_merge (1.2.1)
     i18n (1.8.5)
       concurrent-ruby (~> 1.0)

@@ -9,6 +10,7 @@ PLATFORMS
   ruby

 DEPENDENCIES
+  deep_merge (= 1.2.1)
   i18n (= 1.8.5)

 BUNDLED WITH
```

### Conclusion

* Expected behavior: Dependencies for all gems that are not changed remain the same.
* Actual behavior: Dependencies for all gems that are not changed remain the same.
* Result: **PASSED**


## Case2: Gemspec

```
$ cd gemspec
```

### Ensure current Gemfile.lock is correct
```
$ bundle install

Using bundler 2.1.4
Using concurrent-ruby 1.1.6
Using i18n 1.8.5
Using dummy 0 from source at `.`
Bundle complete! 1 Gemfile dependency, 4 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

```
$ git diff
(EMPTY)
```

### Adding new gem to gemspec

```
$ WITH_NEW_GEM=1 bundle install

Fetching gem metadata from https://rubygems.org/...
Resolving dependencies...
Using bundler 2.1.4
Using concurrent-ruby 1.1.7 (was 1.1.6)
Using deep_merge 1.2.1
Using i18n 1.8.5
Using dummy 0 from source at `.`
Bundle complete! 1 Gemfile dependency, 5 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

```
$ git diff

--- a/gemspec/Gemfile.lock
+++ b/gemspec/Gemfile.lock
@@ -2,12 +2,14 @@ PATH
   remote: .
   specs:
     dummy (0)
+      deep_merge (= 1.2.1)
       i18n (= 1.8.5)

 GEM
   remote: https://rubygems.org/
   specs:
-    concurrent-ruby (1.1.6)
+    concurrent-ruby (1.1.7)
+    deep_merge (1.2.1)
     i18n (1.8.5)
       concurrent-ruby (~> 1.0)
```


### Conclusion

* Expected behavior: Dependencies for all gems that are not changed remain the same.
* Actual behavior: Dependencies for all gems that are not changed UPGRADED to newest version.
* Result: **FAILED**

Details:

`concurrent-ruby` upgraded from `1.1.6` to `1.1.7` which is NOT expected thus it was locked.


## Case3: Path

Same as Case2.


## Gem dependencies

```
$ gem dependency i18n -v 1.8.5

Gem i18n-1.8.5
  concurrent-ruby (~> 1.0)
```

```
$ gem dependency concurrent-ruby -v1.1.6
Gem concurrent-ruby-1.1.6
```

```
$ gem dependency deep_merge -v 1.2.1

Gem deep_merge-1.2.1
  rake (~> 10.1, development)
  test-unit-minitest (>= 0, development)
```
