---
title: Working With Strings in windows-rs
date: 2022-10-23T13:07:35+11:00
---

The [windows-rs](https://crates.io/crates/windows) crate is an incredible addition to the Rust ecosystem and provides bindings for the entire Win32 SDK for Rust developers.  It is also lead by some incredibly engaged and telanted developers such as [Kenny Kerr](https://github.com/kennykerr) and [Rafael Rivera](https://github.com/riverar).

This post discusses the various string types which are used in the crate and how you can interact with them.  These ultimately originate in the Win32 C++ SDKs and may be familiar to those who have developed Windows applications in C++ in the past; but maybe not to those approaching it with Rust for the first time.

There are two options available in most Win32 SDKs; the ANSI variants and the wide variants.  Most available functions come in two variants to cater for this and use the A and W suffixes respectively.

e.g. [CreateFileA](https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/Storage/FileSystem/fn.CreateFileA.html) vs [CreateFileW](https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/Storage/FileSystem/fn.CreateFileW.html)

Further details about each of these variants will be discussed below.

Let's start by discussing the various string types available along with their use.

## HSTRING: An immutable owned reference-counted wide UTF-16 nul-terminated string

HSTRING is a modern implementation of strings for Windows developers intended for use in WinRT applications.  WinRT is a modern SDK introduced in Windows 8 for developing Windows applications.

The HSTRING type is very easy to interoperate with in Rust:

```rust
let text = "Hello there mate! 😊";
let text = HSTRING::from(text);
let text = text.to_string();
assert_eq!("Hello there mate! 😊", &text);
```

Furthermore, HSTRING deals gracefully with interior nul characters:

```rust
let text = "Hello there mate! 😊\0Hidden text";
let text = HSTRING::from(text);
let text = text.to_string();
assert_eq!("Hello there mate! 😊\0Hidden text", &text);
```

If you require a `HSTRING` slice (i.e. `&HSTRING`) which is created at compile-time, you may also use the `w!` macro to create one:

```rust
let text = w!("Hello there mate! 😊");
let text = text.to_string();
assert_eq!("Hello there mate! 😊", &text);
```

One minor drawback of HSTRING (compared to various other string types) is that a HSTRING requires 40 bytes of memory excluding the string itself.  This is due to the header which is used to keep track of the reference count, string length and various other metadata along with the pointer to the header.

## PCWSTR: Pointer to a constant wide (UTF-16) nul-terminated string

The definition of a PCWSTR is as follows:

```rust
pub struct PCWSTR(pub *const u16);
```

It is simply a pointer to a UTF-16 string which will be terminated when the first nul (i.e. `0`) is encountered.

One extremely important point about this type of string is that it does not own the data it points to; so it is important that the lifetime of the underlying buffer is considered carefully.

There are several ways to construct a PCWSTR from a `&str`:

```rust
// Using a HSTRING.
let text = "Hello there mate! 😊";
let text = HSTRING::from(text);
let text = PCWSTR::from(&text);
let text = unsafe { text.to_string() }.unwrap();
assert_eq!("Hello there mate! 😊", &text);

// By creating a vector of UTF-16 characters with a nul terminator yourself.
let text = "Hello there mate! 😊";
let text = text.encode_utf16().chain(iter::once(0)).collect::<Vec<_>>();
let text = PCWSTR::from_raw(text.as_ptr());
let text = unsafe { text.to_string() }.unwrap();
assert_eq!("Hello there mate! 😊", &text);

// By creating a boxed slice of UTF-16 characters with a nul terminator.  This takes slightly
// less memory than a vector which is padded.
let text = "Hello there mate! 😊";
let text = text.encode_utf16().chain(iter::once(0)).collect::<Box<_>>();
let text = PCWSTR::from_raw(text.as_ptr());
let text = unsafe { text.to_string() }.unwrap();
assert_eq!("Hello there mate! 😊", &text);

// By using the awesome widestring library at https://crates.io/crates/widestring
let text = "Hello there mate! 😊";
let text = U16CString::from_str(text).unwrap();
let text = PCWSTR::from_raw(text.as_ptr());
let text = unsafe { text.to_string() }.unwrap();
assert_eq!("Hello there mate! 😊", &text);
```

Interior nul characters will truncate the string when calling `to_string` on the `PCWSTR` variable so it's important to avoid interior nul characters.

The widestring library will throw an error if interior nuls are present when using the `from_str` function.

e.g.

```rust
// Using a HSTRING.
let text = "Hello there mate! 😊\0Hidden text";
let text = HSTRING::from(text);
let text = PCWSTR::from(&text);
let text = unsafe { text.to_string() }.unwrap();
assert_eq!("Hello there mate! 😊", &text);

// By creating a vector of UTF-16 characters with a nul terminator yourself.
let text = "Hello there mate! 😊\0Hidden text";
let text = text.encode_utf16().chain(iter::once(0)).collect::<Vec<_>>();
let text = PCWSTR::from_raw(text.as_ptr());
let text = unsafe { text.to_string() }.unwrap();
assert_eq!("Hello there mate! 😊", &text);

// By creating a boxed slice of UTF-16 characters with a nul terminator.  This takes slightly
// less memory than a vector which is padded.
let text = "Hello there mate! 😊\0Hidden text";
let text = text.encode_utf16().chain(iter::once(0)).collect::<Box<_>>();
let text = PCWSTR::from_raw(text.as_ptr());
let text = unsafe { text.to_string() }.unwrap();
assert_eq!("Hello there mate! 😊", &text);

// By using the awesome widestring library at https://crates.io/crates/widestring
let text = "Hello there mate! 😊\0Hidden text";
assert!(U16CString::from_str(text).is_err());
```

In terms of memory usage, the `U16CString` and the boxed slice approach shown above should be most efficient (taking 24 bytes less than a `HSTRING`).  Personally I recommend using the [widestring](https://crates.io/crates/widestring) crate and `U16CString` as it is both safer and more memory efficient than the conversion from a `HSTRING` which is offered by windows-rs.

One handy aspect of `HSTRING` is the fact that it'll automatically be converted into a PCWSTR when passed as a function parameter; and thus you'll need to weigh up whether that convenience is worth it for your use case.

## PWSTR: Pointer to a mutable wide (UTF-16) nul-terminated string

The definition of a PWSTR is as follows:

```rust
pub struct PWSTR(pub *mut u16);
```

PWSTR is similar to PCWSTR except that the pointer to the string must be mutable.  PWSTR is often used when a function needs to write a string to a parameter.

e.g. check out the `name` and `referenceddomainname` parameters of `LookupAccountSidW`

```rust
pub unsafe fn LookupAccountSidW<'a, P0, P1>(
    lpsystemname: P0,
    sid: P1,
    name: PWSTR,
    cchname: *mut u32,
    referenceddomainname: PWSTR,
    cchreferenceddomainname: *mut u32,
    peuse: *mut SID_NAME_USE
) -> BOOLwhere
    P0: Into<PCWSTR>,
    P1: Into<PSID>,
```

In most cases, you'll need to allocate an underlying buffer and tell the function how large the buffer is.  In some cases the size of the buffer will be easy to know ahead of time (e.g. for paths, the length is typically `MAX_PATH`), however in other cases functions may be called with a null pointer first to obtain the required length before allocation occurs.

Let's look at a typical approach for allocating a buffer for wide strings using the `GetVirtualDiskPhysicalPath` function:

```rust
// Allocate a buffer and determine the size in bytes.
let mut physical_path_buffer = [0_u16; MAX_PATH as usize];
let mut physical_path_buffer_size = mem::size_of::<[u16; MAX_PATH as usize]>() as u32;

// Call the function with a pointer to the mutable buffer.
let status = unsafe {
    GetVirtualDiskPhysicalPath(
        info_handle,
        &mut physical_path_buffer_size,
        PWSTR::from_raw(physical_path_buffer.as_mut_ptr()),
    )
};

// Convert the returned string into a Rust String.
let physical_path =
    unsafe { PCWSTR::from_raw(physical_path_buffer.as_ptr()).to_string() }.unwrap();
```

It is critically important to note that functions often differ in the way they accept such arguments.  Sometimes the function will request the length of your buffer, other times (as shown above) the function may request the size on bytes.  Occasionally, functions may simply accept a `&mut [u16]` instead of a `PWSTR`.

The result of all these variants is largely the same but you'll need to ensure you follow the specification of the function exactly to avoid trouble.

As windows-rs matures, it will hopefully hide such details from the user.

## PCSTR: Pointer to a constant ANSI (or UTF-8) nul-terminated string

The definition of a PCSTR is as follows:

```rust
pub struct PCSTR(pub *const u8);
```

Prior to the UTF-16 standard in Windows programming, Windows typically supported an extended version of ASCII encoding.  Most commonly this would be [Windows 1252](https://en.wikipedia.org/wiki/Windows-1252) encoding which added an additional 128 characters to the base ASCII set.  This could vary depend on your region however and there were many more similar encodings available which tailored those additional 128 characters to specific regions.

As of Windows Version 1903, Microsoft [introduced a way to re-purpose these strings to use UTF-8](https://learn.microsoft.com/en-us/windows/apps/design/globalizing/use-utf8-code-page) instead of the legacy ANSI standard that was used in the past.  The solution involves the introduction of a manifest that must be applied to your executable using Microsoft's `mt.exe` tool which does complicate matters and I'm personally not sure if all relevant SDKs fully support this.  Thus the current recommendation is to always use wide strings and the respective functions containing the `W` suffix.

However, there are sadly a few specific situations where this is not possible as wide equivalents do not exist.

## PSTR: Pointer to a mutable ANSI nul-terminated string

The definition of a PSTR is as follows:

```rust
pub struct PSTR(pub *mut u8);
```

This is the mutable equivalent of PWSTR but for ANSI strings.

## BSTR: An immutable owned wide UTF-16 nul-terminated string used for COM interop

This is the string type you'll come across the least and will only pop up if you use specific functions that relate to COM or other niche areas that BSTR is used.

It's fortunately a very easy string type to work with, much like HSTRING:

```rust
let text = "Hello there mate! 😊";
let text = BSTR::from(text);
let text = text.to_string();
assert_eq!("Hello there mate! 😊", &text);
```

It also seems to deal gracefully with interior nuls:

```rust
let text = "Hello there mate! 😊\0Hidden text";
let text = BSTR::from(text);
let text = text.to_string();
assert_eq!("Hello there mate! 😊\0Hidden text", &text);
```

## Summary

In daily use, you should generally stick with `W` suffix functions when writing Windows software in Rust.  Due to this, you'll most commonly be dealing with `PCWSTR` and `PWSTR` string types which are trouble-free as long as you remember the following:

- A `PCWSTR` is just a pointer to data and doesn't own the data at all; so ensure this data type is always backed by concrete storage such as `U16CString` or `HSTRING`
- Much like `PCWSTR`, `PWSTR` also doesn't have any underlying storage, so a buffer will almost always be required when a function requests a `PWSTR` to write to

Happy Windows Rust coding!
