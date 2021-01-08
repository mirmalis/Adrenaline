begin
  User.SetVar(Cardinal(@User));
  Print(TL2User(User.GetVar^).Name);
end.