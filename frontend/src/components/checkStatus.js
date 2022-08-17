import React from "react";

export function checkStatus({ checkStatus}) {
  return (
    <div>
      <form
        onSubmit={(event) => {
          // This function just calls the transferTokens callback with the
          // form's data.
          event.preventDefault();

          const formData = new FormData(event.target);
          const to = formData.get("to");
          const metadata_url = formData.get("metadata_url");

          if (to && metadata_url) {
            mintClaim(to, metadata_url);
          }
        }}
      >
        <div className="form-group">
          <label>Metadata Url</label>
          <input className="form-control" type="text" name="metadata_url" required/>
        </div>
        <div className="form-group">
          <label>Company address</label>
          <input className="form-control" type="text" name="to" required />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Mint" />
        </div>
      </form>
    </div>
  );
}
