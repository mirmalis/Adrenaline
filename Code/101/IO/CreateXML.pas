uses nativeXML;
procedure CreateXML;
var
  ADoc: TNativeXml;
begin
  // Create new document with a rootnode called "Root"
  ADoc := TNativeXml.CreateName('Root', nil);
  try
    // Add a subnode with name "Customer"
    with ADoc.Root.NodeNew('Customer') do begin
      // Add an attribute to this subnode
      WriteAttributeInteger('ID', 123456, -1);
      // Add subsubnode
      WriteString('Name', 'John Doe', '');
    end;

    // Save the XML in readable format (so with indents)
    ADoc.XmlFormat := xfReadable;
    // Save results to a file
    ADoc.SaveToFile('c:\test.xml');
    Print('c:\test.xml created');
  finally
    ADoc.Free;
  end;
end;

begin
  CreateXML;
end.