Feature: Forms in Lyncex

Scenario: Save content of a form
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    When I submit the form '/form1' with data '_id=https://app.lyncex.com/book/Quijote' and 'name=Don Quijote'
    Then I visit '/book?id=Quijote'
    And I get a '<b>Name: </b>Don Quijote' response
    And I get a 'text/html' response type
    And I get a 200 status code

Scenario: Save content of a form (valid)
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    When I submit the form '/form2' with data '_id=https://app.lyncex.com/book/Quijote' and 'xname=Quijote'
    Then I visit '/book2?id=Quijote'
    And I get a '<b>Name: </b>Quijote' response
    And I get a 200 status code
    And I get a 'text/html' response type

Scenario: Save content of a form (invalid)
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    When I submit the form '/form2' with data '_id=https://app.lyncex.com/book/Quijote' and 'xname=Don Quijote'
    Then I visit '/book2?id=Quijote'
    And I get a 500 status code

Scenario: Autogenerate form
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    When I visit '/form1'
    And I get a '<form method="POST"><input type="url" name="_id" value="https://app.lyncex.com/book/"><input type="text" placeholder="https://app.lyncex.com/name" name="https://app.lyncex.com/name"><input type="submit" value="Añadir"></form>' response
    And I get a 'text/html' response type
    And I get a 200 status code

Scenario: Multiple triples (generated form)
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    When I visit '/form3'
    And I get a '<form method="POST"><input type="url" name="_id" value="https://app.lyncex.com/book/"><textarea placeholder="https://app.lyncex.com/author" name="https://app.lyncex.com/author"></textarea><input type="submit" value="Añadir"></form>' response
    And I get a 'text/html' response type
    And I get a 200 status code

Scenario: Multiple triples (save)
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    When I submit the form '/form3' with data '_id=https://app.lyncex.com/book/SuperLibro' and 'author=small'
    Then I visit '/book3?id=SuperLibro'
    And I get a '<b>Authors: </b>Cervantes,Lope de Vega,' response
    And I get a 200 status code
    And I get a 'text/html' response type

Scenario: Visualize saved triples
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    And I submit the form '/form3' with data '_id=https://app.lyncex.com/book/SuperLibro' and 'author=small'
    When I visit '/form3?_id=https://app.lyncex.com/book/SuperLibro'
    Then I get the following response
        """
        <form action="/form3" method="POST"><input readonly type="url" name="_id" value="https://app.lyncex.com/book/SuperLibro"><textarea placeholder="https://app.lyncex.com/author" name="https://app.lyncex.com/author">Cervantes
        Lope de Vega
        </textarea><input type="submit" value="Editar"></form><form method="GET"><input type="hidden" name="_delete" value="yes"><input type="hidden" name="_id" value="https://app.lyncex.com/book/SuperLibro"><input type="submit" value="Borrar"></form>
        """
    And I get a 200 status code
    And I get a 'text/html' response type

Scenario: Delete triples
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    And I submit the form '/form3' with data '_id=https://app.lyncex.com/book/SuperLibro' and 'author=small'
    When I visit '/form3?_delete=yes&_id=https://app.lyncex.com/book/SuperLibro'
    Then I get a 'OK' response
    And I get a 200 status code
    And I get a 'text/html' response type

Scenario: Update triples (add more)
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    And I submit the form '/form3' with data '_id=https://app.lyncex.com/book/SuperLibro' and 'author=small'
    When I submit the form '/form3' with data '_id=https://app.lyncex.com/book/SuperLibro' and 'author=large'
    Then I visit '/book3?id=SuperLibro'
    And I get a '<b>Authors: </b>Cervantes,Lope de Vega,Pepito,' response
    And I get a 200 status code
    And I get a 'text/html' response type

Scenario: Update triples (delete)
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    And I submit the form '/form3' with data '_id=https://app.lyncex.com/book/SuperLibro' and 'author=large'
    When I submit the form '/form3' with data '_id=https://app.lyncex.com/book/SuperLibro' and 'author=small'
    Then I visit '/book3?id=SuperLibro'
    And I get a '<b>Authors: </b>Cervantes,Lope de Vega,' response
    And I get a 200 status code
    And I get a 'text/html' response type

Scenario: Form also work for relationships
    Given I have an empty Lyncex instance
    And I do a POST request with 'features/test4.ttl' data
    And I submit the form '/form4' with data '_id=https://app.lyncex.com/person/Mario' and 'friend=https://app.lyncex.com/person/Jaime'
    Then I visit '/form4?_id=https://app.lyncex.com/person/Mario'
    And I get the following response
    """
    <form action="/form4" method="POST"><input readonly type="url" name="_id" value="https://app.lyncex.com/person/Mario"><textarea placeholder="https://app.lyncex.com/friend" name="https://app.lyncex.com/friend">https://app.lyncex.com/person/Jaime
    </textarea><input type="submit" value="Editar"></form><form method="GET"><input type="hidden" name="_delete" value="yes"><input type="hidden" name="_id" value="https://app.lyncex.com/person/Mario"><input type="submit" value="Borrar"></form>
    """
    And I get a 200 status code
    And I get a 'text/html' response type
    And I visit '/person4'
    And I get a '<b>Friend: </b>https://app.lyncex.com/person/Jaime' response
    And I get a 200 status code
    And I get a 'text/html' response type



