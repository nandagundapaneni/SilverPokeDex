# SilverPokeDex Debugging Mock Assessment

Timebox: 1 hour 45 minutes.

This is a Speechify-style iOS debugging exercise using real API data from PokeAPI. The project compiles, but it contains intentional bugs and senior-level pitfalls.

## Rules

- Work task-by-task.
- Build and run after each meaningful fix.
- Commit after each task.
- Prefer small, maintainable changes over broad rewrites.

## Tasks

### Task 1 — SwiftUI lifecycle and navigation

The list screen owns its view model incorrectly and uses older navigation APIs. Fix the lifecycle bug and modernize navigation where appropriate.

Expected behavior:
- View model should not be recreated unexpectedly.
- Navigation should be iOS 16+ friendly.

### Task 2 — Loading, empty, and error states

The current UI shows a spinner whenever the list is empty, even if loading failed or no results match the search.

Expected behavior:
- Show a loading state only when actually loading.
- Show an error message when loading fails.
- Show an empty/search state when appropriate.

### Task 3 — API robustness

The API layer does not validate HTTP responses and force unwraps network data in the legacy API.

Expected behavior:
- Validate HTTP status codes.
- Avoid force unwraps.
- Surface useful errors.

### Task 4 — Parallel fetching

The app currently fetches Pokémon detail records sequentially. Improve loading performance by fetching details concurrently.

Expected behavior:
- Fetch details in parallel using Swift Concurrency.
- Avoid duplicate rows on refresh.
- Preserve list order if you choose a TaskGroup implementation.

### Task 5 — Memory leaks

There are retain cycles involving a Combine subscription and a repeating Timer.

Expected behavior:
- ViewModel should deallocate correctly.
- Timer should be invalidated and released.
- Combine closures should not strongly retain the ViewModel.

### Task 6 — DispatchGroup bug

`fetchLegacyDashboard` has a DispatchGroup error-path bug and unsafe shared mutable state.

Expected behavior:
- Every `group.enter()` must have a matching `group.leave()` on all paths.
- Protect shared mutable state if callbacks complete on different queues.
- Complete on the main queue.

### Task 7 — Crash risk

Some views assume the abilities array always has at least one item.

Expected behavior:
- No array index crashes.
- Display a fallback if no abilities are available.

### Task 8 — Swift 6 cleanup

Review the project for Swift 6 concurrency warnings, unnecessary force unwraps, and code that is hard to maintain.

Expected behavior:
- Clean build.
- No obvious force unwraps in networking or UI.
- Clear, maintainable implementation.

## Suggested commit messages

- `Fix SwiftUI lifecycle and navigation issues`
- `Add loading error and empty states`
- `Harden Pokemon API error handling`
- `Fetch Pokemon details concurrently`
- `Fix timer and Combine retain cycles`
- `Fix DispatchGroup error handling`
- `Prevent crashes from empty ability lists`
