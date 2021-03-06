:- module(main, [run/0]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_unix_daemon)).
:- use_module(library(http/http_session)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_write)).
:- use_module(library(semweb/rdf11)).

:- use_module(library(http/http_error)).

:- use_module('api.pl').
:- use_module('prefix.pl').
:- use_module('errorpage.pl').

:- use_module('controllers/login.pl').
:- use_module('controllers/form.pl').
:- use_module('controllers/template.pl').
:- use_module('controllers/content.pl').

:- http_handler(root(Path), controller(Path, Method), [method(Method)]).

controller(P, M, R) :-
    rdf(Controller, lyncex:url, P^^xsd:string),
    rdf(Controller, lyncex:access, "private"^^xsd:string),
    http_session_data(user(_)),
    call_controller(P, M, R).

controller(P, _M, _R) :-
    rdf(Controller, lyncex:url, P^^xsd:string),
    rdf(Controller, lyncex:access, "private"^^xsd:string),
    \+ http_session_data(user(_)),
    throw(http_reply(forbidden(P))).

controller(P, M, R) :-
    rdf(Controller, lyncex:url, P^^xsd:string),
    \+ rdf(Controller, lyncex:access, "private"^^xsd:string),
    call_controller(P, M, R).

controller(_Path, _Method, Request) :-
    http_404([], Request).

call_controller(P, M, R) :-
    http_parameters(R, [], [form_data(FormData)]),
    (
        login_controller(P, M, R, FormData);
        form_controller(P, M, R, FormData);
        template_controller(P, M, R, FormData);
        content_controller(P, M, R)
    ).

run :-
    http_daemon([port(11011),fork(false)]).